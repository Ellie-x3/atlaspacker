class_name ReorderButton
extends ToolBarButton

@onready var project_view: ProjectView = owner as ProjectView

func _on_pressed()-> void:
    project_view.request_data.emit()
    project_view.remove_sprites()
