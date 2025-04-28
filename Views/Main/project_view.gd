class_name ProjectView
extends Node2D

signal request_data
signal data_reorder

static var selected_sheet: TextureRect = null
static var selected_frame: Dictionary[String, Variant]

@onready var _open_button: ToolBarButton = %OpenButton

@onready var _images_container: Node2D = $Images
@onready var _line_edit: LineEdit = %LineEdit

var image_paths: Dictionary[Image, String] = {}
var images_data: Array[ImageData]
var rect_image_data: Dictionary[TextureRect, ImageData]

var hovered_sprite: TextureRect = null
var selected_sprite: TextureRect = null

var most_frames: int

func _init() -> void:
	RenderingServer.set_default_clear_color(Color8(220,220,220))

func _ready() -> void:
	_open_button.files_given.connect(func(files: PackedStringArray) -> void:

		image_paths = {}
		images_data = []
		selected_frame = {}

		for file: String in files:
			var file_name: String = file.get_basename().get_file()
			if not file_name.contains("_"):
				printerr("File name is not formatted correctly, name_framecount expected got: ", file_name)
				return
			var split_name: PackedStringArray = file_name.split("_")

			if split_name.is_empty() or split_name.size() != 2:
				printerr("Only one _ is allowed got: ", file_name)

		create_images_from_files(files)

		if images_data.is_empty():
			printerr("Could not properly set image data, go yell at Ellie for fucking up; this error shouldnt show")
			return
	)

	data_reorder.connect(func() -> void: 
		remove_sprites()
		create_sprite_from_texture(images_data)
	)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and hovered_sprite != null:
		_on_click()
	
	if Input.is_action_just_pressed("ui_up") and selected_sprite != null and not PixelButton.setting_pixel_data:
		var index: int = images_data.find(rect_image_data[selected_sprite])
		if index != 0:
			images_data[index] = images_data[index - 1]
			images_data[index - 1] = rect_image_data[selected_sprite]
			data_reorder.emit()

	if Input.is_action_just_pressed("ui_down") and selected_sprite != null and not PixelButton.setting_pixel_data:
		var index: int = images_data.find(rect_image_data[selected_sprite])
		if index != images_data.size() - 1:
			images_data[index] = images_data[index + 1]
			images_data[index + 1] = rect_image_data[selected_sprite]
			data_reorder.emit()

	
func create_images_from_files(files: PackedStringArray) -> void:
	for img: String in files:
		var image = Image.load_from_file(img)
		image_paths[image] = img
	
	set_image_data()
	
func set_image_data() -> void:
	for img: Image in image_paths.keys():
		var data: ImageData = ImageData.new()
		data.height = img.get_height()
		data.width = img.get_width()
		data.path = image_paths[img]

		var file_name: String = data.path.get_basename().get_file()

		var split_name: PackedStringArray = file_name.split("_")

		if int(split_name[1]) != 0 and typeof(int(split_name[1])) == TYPE_INT:
			data.frames = int(split_name[1])

		most_frames = max(most_frames, data.frames)
		data.texture = create_texture_from_image(img)
		images_data.append(data)
	
	create_sprite_from_texture(images_data)
	image_paths = {}

func create_sprite_from_texture(data: Array[ImageData]) -> void:
	var y_offset: float = 0

	for image: ImageData in data:
		var sprite: TextureRect = TextureRect.new()
		sprite.texture = image.texture
		sprite.position.x = 0
		sprite.position.y = y_offset

		sprite.mouse_entered.connect(func() -> void: 
			hovered_sprite = sprite
		)
		sprite.mouse_exited.connect(func() -> void:
			hovered_sprite = null
			if sprite.draw.is_connected(_on_draw):
				sprite.draw.disconnect(_on_draw)
		)

		y_offset += image.texture.get_height()

		_images_container.add_child(sprite)
		rect_image_data[sprite] = image

func remove_sprites() -> void:
	var children: Variant = _images_container.get_children()
	for sprite: Variant in children:
		if sprite is TextureRect:
			_images_container.remove_child(sprite)
			sprite.queue_free()
			selected_sprite = null

func _on_draw() -> void:
	var thicc: int = 5
	hovered_sprite.draw_line(Vector2(0, 0), Vector2(hovered_sprite.texture.get_width(), 0), Color.ORANGE, thicc)
	hovered_sprite.draw_line(Vector2(0, 0), Vector2(0, hovered_sprite.texture.get_height()), Color.ORANGE, thicc)

	hovered_sprite.draw_line(Vector2(0, hovered_sprite.texture.get_height()), Vector2(hovered_sprite.texture.get_width(), hovered_sprite.texture.get_height()), Color.ORANGE, thicc)
	hovered_sprite.draw_line(Vector2(hovered_sprite.texture.get_width(), 0), Vector2(hovered_sprite.texture.get_width(), hovered_sprite.texture.get_height()), Color.ORANGE, thicc)

func _on_draw_frame(x_position: int, frame_size: int, height: int) -> void:
	var thicc: int = 4
	hovered_sprite.draw_line(Vector2(x_position, 0), Vector2(x_position + frame_size, 0), Color.RED, thicc)
	hovered_sprite.draw_line(Vector2(x_position, 0), Vector2(x_position, height), Color.RED, thicc)

	hovered_sprite.draw_line(Vector2(x_position, height), Vector2(x_position + frame_size, height), Color.RED, thicc)
	hovered_sprite.draw_line(Vector2(x_position + frame_size, 0), Vector2(x_position + frame_size, height), Color.RED, thicc)

func _on_click() -> void:
	match PixelButton.setting_pixel_data:
		false:
			selected_frame = {}
			for rect: Variant in _images_container.get_children():
					if rect is TextureRect:
						if rect != hovered_sprite:
							if rect.draw.is_connected(_on_draw_frame):
								rect.draw.disconnect(_on_draw_frame)
							rect.queue_redraw()

			selected_sprite = hovered_sprite
			selected_sheet = hovered_sprite

			if selected_sprite.draw.is_connected(_on_draw_frame):
				selected_sprite.draw.disconnect(_on_draw_frame)
				selected_sprite.queue_redraw()
				
			if selected_sprite.draw.is_connected(_on_draw):
				selected_sprite.draw.disconnect(_on_draw)
				selected_sprite.queue_redraw()
				return

			selected_sprite.draw.connect(_on_draw)
			selected_sprite.queue_redraw()
				
		true:
			if selected_sprite == null:
				push_error("Fucked up getting correct texture when setting pixel data, yell at ellie")
				return
			
			if hovered_sprite != selected_sprite:
				return

			var mouse_position_x: float = get_local_mouse_position().x - _images_container.position.x
			var frame_size_x: float = rect_image_data[selected_sprite].width / rect_image_data[selected_sprite].frames
			var frame_clicked: float = (mouse_position_x / frame_size_x) + 1
			frame_clicked = floor(frame_clicked)
			
			var offset_x: float = (frame_clicked - 1) * frame_size_x
			if selected_sprite.draw.is_connected(_on_draw_frame):
				selected_sprite.draw.disconnect(_on_draw_frame)
				selected_sprite.queue_redraw()

			if selected_sprite.draw.is_connected(_on_draw):
					selected_sprite.draw.disconnect(_on_draw)
			
			selected_sprite.draw.connect(_on_draw)
			selected_sprite.draw.connect(_on_draw_frame.bind(offset_x, frame_size_x, rect_image_data[selected_sprite].height))
			selected_sprite.queue_redraw()

			selected_frame["Position"] = Vector2(offset_x, 0)
			selected_frame["Frame"] = frame_clicked
			selected_frame["Image"] = rect_image_data[selected_sprite]
			selected_frame["Size"] = Vector2(frame_size_x, rect_image_data[selected_sprite].height)

			_line_edit.show()

func create_texture_from_image(img: Image) -> ImageTexture:
	return ImageTexture.create_from_image(img)

func _on_export_pressed() -> void:
	var children: Array = _images_container.get_children()

	var textures: Array[TextureRect] = []
	for texture: Variant in children:
		if texture is TextureRect:
			textures.append(texture)
	
	if textures == []:
		printerr("Could not get textures")
		return
	
	var max_height: int = 0
	var max_width: int = 0

	for texture: TextureRect in textures:
		max_width = max(max_width, texture.texture.get_width()) 
		max_height += texture.texture.get_height()

	var image: Image = Image.create(max_width, max_height, true, Image.FORMAT_RGBA8)

	var current_y: int = 0
	for texture: ImageData in images_data:
		var img: ImageTexture = texture.texture
		if img:
			var tex_image = img.get_image()
			image.blit_rect(tex_image, Rect2(Vector2.ZERO, tex_image.get_size()), Vector2(0, current_y))
			current_y += tex_image.get_height()

	image = PixelData.set_pixel(Vector2i(image.get_width() - 1, image.get_height() - 1), 90, image)
	image = PixelData.set_pixel(Vector2i(image.get_width() - 2, image.get_height() - 1), 116, image)
	image = PixelData.set_pixel(Vector2i(image.get_width() - 3, image.get_height() - 1), 114, image)
	image = PixelData.set_pixel(Vector2i(image.get_width() - 4, image.get_height() - 1), 97, image)
	image = PixelData.set_pixel(Vector2i(image.get_width() - 5, image.get_height() - 1), 121, image)

	image = PixelData.set_pixel(Vector2i(image.get_width() - 6, image.get_height() - 1), _images_container.get_child_count(), image)
	image = PixelData.set_pixel(Vector2i(image.get_width() - 7, image.get_height() - 1), most_frames, image)

	var err: Error = image.save_png("user://cutscenename_framecount.png")

	if err == OK:
		print("Exported!")
	else:
		printerr("Failed to export: ", err)
