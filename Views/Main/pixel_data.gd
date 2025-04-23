class_name PixelData
extends Node

static func set_data(_data: int, _frame: Dictionary, images: Array[ImageData], y: int = 0) -> void:
	var index: int = images.find(_frame["Image"])

	var img: Image = images[index].texture.get_image()

	img.set_pixel(_frame["Position"].x + 0, y, Color8(90,0,0,0))
	img.set_pixel(_frame["Position"].x + 1, y, Color8(116,0,0,0))
	img.set_pixel(_frame["Position"].x + 2, y, Color8(114,0,0,0))
	img.set_pixel(_frame["Position"].x + 3, y, Color8(97,0,0,0))
	img.set_pixel(_frame["Position"].x + 4, y, Color8(121,0,0,0))
	img.set_pixel(_frame["Position"].x + 5, y, Color8(_data,0,0,0))

	images[index].texture = ImageTexture.create_from_image(img)

static func set_pixel(pixel: Vector2i, data: Variant, image: Image) -> Image:
	if data is String:
		if data.length() != 1:
			push_error("Data must be a single character")
			return null

	if data is not int and data is not String:
		push_error("Data must be a number or a character")
		return null
	
	image.set_pixel(pixel.x, pixel.y, Color8(data, 0, 0, 0))
	return image

static func read_pixel_data(_frame: Dictionary) -> int:
	var img: Image = _frame["Image"].texture.get_image()

	var pixels: int = 6
	var res: String = ""

	for i: int in pixels - 1:
		res += char(floor(img.get_pixel(_frame["Position"].x + i, 0).r * 255))

	if res == "ztray":
		return floor(img.get_pixel(_frame["Position"].x + 6, 0).r * 255)
	
	return 0

static func read_pixel_data_at_pos(x: int, y: int, image: ImageData) -> void:
	var img: Image = image.texture.get_image()

	print(floor(img.get_pixel(x, y).r * 255))

static func read_pixel_data_at_pos_image(x: int, y: int, image: Image) -> void:
	print(floor(image.get_pixel(x, y).r * 255))
