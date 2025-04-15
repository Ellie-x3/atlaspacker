class_name ToolBarButton
extends Button

signal transfer_data(data: Array[ImageData])

func _ready() -> void:
    pressed.connect(_on_pressed)

func _on_pressed() -> void:
    printerr("Virtual function needs to be overrided")