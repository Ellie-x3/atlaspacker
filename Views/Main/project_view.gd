class_name ProjectView
extends Node2D

signal request_data

@onready var _open_button: ToolBarButton = %OpenButton
@onready var _resize_button: ResizeButton = %ResizeButton
@onready var _images_container: Node2D = $Images

var image_paths: Dictionary[Image, String] = {}
var images: Array[Image] = []
var images_data: Array[ImageData]
var textures: Dictionary[String, ImageTexture]

var hovered_sprite: TextureRect = null

func _init() -> void:
	RenderingServer.set_default_clear_color(Color8(220,220,220))

func _ready() -> void:
	_open_button.files_given.connect(func(files: PackedStringArray) -> void:

		image_paths = {}
		images_data = []
		images = []
		textures = {}

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

	request_data.connect(func() -> void: 
		if images_data.is_empty():
			printerr("There is not image data to transfer")
			return

		_resize_button.transfer_data.emit(images_data)
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and hovered_sprite != null:
		print(hovered_sprite.name)
	
	if event.is_action_pressed("ui_up"):
		pass

func create_images_from_files(files: PackedStringArray) -> void:
	for img: String in files:
		var image = Image.load_from_file(img)
		images.append(image)
		image_paths[image] = img
	
	set_image_data()
	
func set_image_data() -> void:
	for img: Image in images:
		var data: ImageData = ImageData.new()
		data.height = img.get_height()
		data.width = img.get_width()
		data.path = image_paths[img]

		var file_name: String = data.path.get_basename().get_file()

		var split_name: PackedStringArray = file_name.split("_")

		if int(split_name[1]) != 0 and typeof(int(split_name[1])) == TYPE_INT:
			data.frames = int(split_name[1])

		data.texture = create_texture_from_image(img)
		images_data.append(data)
	
	create_sprite_from_texture(images_data)

func create_sprite_from_texture(data: Array[ImageData]) -> void:
	var y_offset: float = 0

	for image: ImageData in data:
		var sprite: TextureRect = TextureRect.new()
		sprite.texture = image.texture
		sprite.position.x = 0
		sprite.position.y = y_offset
		
		sprite.draw.connect(func() -> void: 
			sprite.draw_line(Vector2(0, 0), Vector2(image.texture.get_width(), 0), Color.ORANGE, 3)
			sprite.draw_line(Vector2(0, 0), Vector2(0, image.texture.get_height()), Color.ORANGE, 3)

			sprite.draw_line(Vector2(0, image.texture.get_height()), Vector2(image.texture.get_width(), image.texture.get_height()), Color.ORANGE, 3)
			sprite.draw_line(Vector2(image.texture.get_width(), 0), Vector2(image.texture.get_width(), image.texture.get_height()), Color.ORANGE, 3)
		)

		sprite.mouse_entered.connect(func() -> void: hovered_sprite = sprite)
		sprite.mouse_exited.connect(func() -> void: hovered_sprite = null)

		y_offset += image.texture.get_height()

		_images_container.add_child(sprite)

func remove_sprites() -> void:
	var children: Variant = _images_container.get_children()
	for sprite: Variant in children:
		if sprite is TextureRect:
			_images_container.remove_child(sprite)
			sprite.queue_free()

func create_texture_from_image(img: Image) -> ImageTexture:
	return ImageTexture.create_from_image(img)
