class_name ResourceStackDisplay extends TextureRect

const hand: CompressedTexture2D = preload("res://scenes/ui/resource/storage/hand.svg")

@export var quantity_font: Font
@export var quantity_size := 16
@export var quantity_color := Color.WHITE
@export var quantity_shadow_color := Color.BLACK

@export var stack: ResourceStack:
	set(val):
		if stack == val: return
		
		global.reconnect(queue_redraw, stack, val, "quantity_changed")
		
		stack = val
		
		if stack and stack.resource_data and stack.resource_data.texture:
			var img := stack.resource_data.texture.get_image()
			img.resize(32, 32, Image.INTERPOLATE_NEAREST)
			resource_texture = ImageTexture.create_from_image(img)
		
		visible = stack != null
		queue_redraw()

@export var in_hand: bool:
	set(val):
		in_hand = val
		texture = hand if in_hand else resource_texture
		size = Vector2.ZERO

var resource_texture: ImageTexture:
	set(val):
		if resource_texture == val: return
		resource_texture = val
		
		in_hand = in_hand

func _draw() -> void:
	if not stack: return
	
	var bottom_right := size - Vector2(quantity_font.get_string_size(str(stack.quantity)).x, 0)
	draw_string(quantity_font, bottom_right - Vector2(2, 2), str(stack.quantity), HORIZONTAL_ALIGNMENT_LEFT, -1, quantity_size, quantity_shadow_color)
	draw_string(quantity_font, bottom_right - Vector2(3, 3), str(stack.quantity), HORIZONTAL_ALIGNMENT_LEFT, -1, quantity_size, quantity_color)
