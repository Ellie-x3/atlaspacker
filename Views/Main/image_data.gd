class_name ImageData
extends Resource

var height: int
var width: int
var path: String

func _to_string() -> String:
    return "Image Data: (Height: %d, Width: %d, Path: %s)" % [height, width, path]