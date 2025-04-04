class_name Menu
extends Control

@onready var _create_button: Button = %Button

func _init() -> void:
	RenderingServer.set_default_clear_color(Color8(19,23,36))

func _ready() -> void:
	_create_button.grab_focus()
