class_name ImageData
extends Resource

var height: int
var width: int
var path: String
var frames: int
var texture: ImageTexture

func _to_string() -> String:
    return "Image Data: (Height: %d, Width: %d, Frames: %d, Path: %s)" % [height, width, frames, path]