class_name PixelButton
extends ToolBarButton

static var setting_pixel_data: bool = false

@onready var project_view: ProjectView = owner as ProjectView
@onready var off_color: Color = get_parent().color
var on_color: Color = Color8(96, 141, 114, 255)

func _on_pressed() -> void:

    if not ProjectView.selected_sheet:
        printerr("Select a spritesheet")

    swap_state(!setting_pixel_data)
    
func swap_state(state: bool) -> void:
    setting_pixel_data = state
    print(setting_pixel_data)
    match setting_pixel_data:
        true:
            get_parent().color = on_color
        false:
            get_parent().color = off_color
