extends Sprite2D

func _ready() -> void:
    var image: Image = texture.get_image()
    print(image.get_meta_list())