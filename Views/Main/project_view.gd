class_name ProjectView
extends Node2D

@onready var _open_button: ToolBarButton = $%OpenButton

var selected_files: PackedStringArray

var image_paths: Dictionary[Image, String] = {}
var images: Array[Image] = []
var images_data: Array[ImageData]

func _init() -> void:
    RenderingServer.set_default_clear_color(Color8(220,220,220))

func _ready() -> void:
    _open_button.files_given.connect(func(files: PackedStringArray) -> void:
        selected_files = files
        create_images_from_files(files)
    )

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
        images_data.append(data)
        var texture: ImageTexture = create_texture_from_image(img)
        print(texture)

func create_texture_from_image(img: Image) -> ImageTexture:
    return ImageTexture.create_from_image(img)