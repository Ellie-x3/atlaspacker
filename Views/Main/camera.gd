extends Camera2D

signal zoomed

@export var zoom_speed: float = 1.0
@export var camera_speed: float = 5.0

func _input(event: InputEvent) -> void:
    if event is InputEventMouse:
        if event.is_action_pressed("ScrollUp"):
            if zoom < Vector2(1,1):
                zoom += Vector2(zoom_speed, zoom_speed)
                zoomed.emit()
        if event.is_action_pressed("ScrollDown"):
            var next_zoom = zoom - Vector2(zoom_speed, zoom_speed)
            if next_zoom >= Vector2.ZERO:
                zoom = next_zoom
                zoomed.emit()

func _process(delta: float) -> void:
    var direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down").normalized()
    var next_pos: = offset + direction

    if next_pos.x * zoom.x < 0:
        offset.x = 0

    offset.x += direction.x * (camera_speed / zoom.x) * delta

    if next_pos.y * zoom.y < 0:
        offset.y = 0

    offset.y += direction.y * (camera_speed / zoom.y) * delta

    if Input.is_action_just_pressed("ui_accept"):
        print(offset)

    