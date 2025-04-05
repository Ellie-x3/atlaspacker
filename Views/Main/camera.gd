extends Camera2D

@export var zoom_speed: float = 1.0

func _input(event: InputEvent) -> void:
    if event is InputEventMouse:
        if event.is_action_pressed("ScrollUp"):
            zoom += Vector2(zoom_speed, zoom_speed)
        if event.is_action_pressed("ScrollDown"):
            var next_zoom = zoom - Vector2(zoom_speed, zoom_speed)
            print(next_zoom)
            if next_zoom >= Vector2.ZERO:
                zoom = next_zoom