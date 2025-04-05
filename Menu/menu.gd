class_name Menu
extends Control

@onready var _create_button: Button = %Button

func _init() -> void:
	RenderingServer.set_default_clear_color(Color8(45,45,45))

func _ready() -> void:
	_create_button.grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Views/Main/project_view.tscn")
