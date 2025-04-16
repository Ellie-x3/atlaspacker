extends ToolBarButton

@onready var camera: Camera2D = %Camera2D
@onready var project_view: ProjectView = owner as ProjectView

func _on_pressed() -> void:
    camera.offset = Vector2.ZERO
    camera.zoom = Vector2.ONE

    PixelData.read_pixel_data_at_pos(0,0, project_view.images_data[0])
    PixelData.read_pixel_data_at_pos(1,0, project_view.images_data[0])
    PixelData.read_pixel_data_at_pos(2,0, project_view.images_data[0])
    PixelData.read_pixel_data_at_pos(3,0, project_view.images_data[0])
    PixelData.read_pixel_data_at_pos(4,0, project_view.images_data[0])
    PixelData.read_pixel_data_at_pos(5,0, project_view.images_data[0])