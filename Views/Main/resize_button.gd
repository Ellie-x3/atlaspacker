class_name ResizeButton
extends Button

signal transfer_data(data: Array[ImageData])

@onready var project_view: ProjectView = owner as ProjectView

var frame_size: Vector2i
var largest_frame: Vector2 = Vector2.ZERO
var largest_spritesheet: Vector2 = Vector2.ZERO
var rows_needed: int = 0

func _ready() -> void:
    transfer_data.connect(_on_transfer)

    pressed.connect(func() -> void:
        project_view.request_data.emit()
    )

func calculate_frames_sizes(images_data: Array[ImageData]) -> Array[Vector2i]:

    var result: Array[Vector2i] = []

    for data: ImageData in images_data:
        result.append(Vector2i((data.width / data.frames), data.height))

    return result

func _on_transfer(data: Array[ImageData]) -> void:
    var x: int = 0
    var y: int = 0

    for frame: Vector2i in calculate_frames_sizes(data):
        x = max(x, frame.x)
        y = max(y, frame.y)
    
    largest_frame = Vector2i(x, y)
    print(data)