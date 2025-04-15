class_name PixelButton
extends ToolBarButton

static var setting_pixel_data: bool = false

@onready var project_view: ProjectView = owner as ProjectView
@onready var off_color: Color = get_parent().color
var on_color: Color = Color8(96, 141, 114, 255)

func _ready() -> void:
    transfer_data.connect(_on_transfer)
    super()

func _on_pressed() -> void:

    if not ProjectView.selected_sheet:
        printerr("Select a spritesheet")

    setting_pixel_data = !setting_pixel_data

    match setting_pixel_data:
        true:
            get_parent().color = on_color
        false:
            get_parent().color = off_color
    
func _on_transfer(data: Array[ImageData]) -> void:
    var img: Image = data[0].texture.get_image()
    img.set_pixel(0,0,Color8(90,0,0,0))
    img.set_pixel(1,0,Color8(116,0,0,0))
    img.set_pixel(2,0,Color8(114,0,0,0))
    img.set_pixel(3,0,Color8(97,0,0,0))
    img.set_pixel(3,0,Color8(121,0,0,0))

    data[0].texture = ImageTexture.create_from_image(img)
    print(data[0].texture.get_image().get_pixel(0,0))
    project_view.data_reorder.emit()