extends ToolBarButton

signal files_given(files: PackedStringArray)

@onready var file_dialog: FileDialog = preload("res://Views/FileDialog/file_dialog.tscn").instantiate()
@onready var menu: Control = %Menu

var files: PackedStringArray = []

func _ready() -> void:
	file_dialog.canceled.connect(_on_window_close)
		
	file_dialog.files_selected.connect(func(_files: PackedStringArray) -> void:
		_on_window_close()
		files = _files
		files_given.emit(files)
	)

	super()

func _on_pressed() -> void:
	if not file_dialog.visible:
		file_dialog.show()
	
	menu.add_child(file_dialog)

func _on_window_close() -> void:
	var dialog: FileDialog = menu.get_children()[0]
	if dialog:
		menu.remove_child(dialog)
