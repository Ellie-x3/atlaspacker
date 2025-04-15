class_name PixelData
extends Node

static func set_pixel_data(_data: int, _frame: Dictionary, images: Array[ImageData]) -> void:
	var index: int = images.find(_frame["Image"])

	var img: Image = images[index].texture.get_image()

	img.set_pixel(_frame["Position"].x + 0, 0, Color8(90,0,0,0))
	img.set_pixel(_frame["Position"].x + 1, 0, Color8(116,0,0,0))
	img.set_pixel(_frame["Position"].x + 2, 0, Color8(114,0,0,0))
	img.set_pixel(_frame["Position"].x + 3, 0, Color8(97,0,0,0))
	img.set_pixel(_frame["Position"].x + 4, 0, Color8(121,0,0,0))
	img.set_pixel(_frame["Position"].x + 5, 0, Color8(_data,0,0,0))

	images[index].texture = ImageTexture.create_from_image(img)

static func read_pixel_data() -> int:
	return 0

	#var img: Image = data[0].texture.get_image()
	#img.set_pixel(0,0,Color8(90,0,0,0))
	#img.set_pixel(1,0,Color8(116,0,0,0))
	#img.set_pixel(2,0,Color8(114,0,0,0))
	#img.set_pixel(3,0,Color8(97,0,0,0))
	#img.set_pixel(3,0,Color8(121,0,0,0))

	#data[0].texture = ImageTexture.create_from_image(img)
	#print(data[0].texture.get_image().get_pixel(0,0))
	#project_view.data_reorder.emit()
