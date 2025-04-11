extends ToolBarButton

@onready var camera: Camera2D = %Camera2D

func _on_pressed() -> void:
    camera.offset = Vector2.ZERO
    camera.zoom = Vector2.ONE