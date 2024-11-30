class_name TiledBackground extends Parallax2D

@export var sprite: Sprite2D:
	set(val):
		sprite = val
		sprite.centered = false
		sprite.region_enabled = true
		sprite.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

func _process(delta: float) -> void:
	if not sprite: return
	
	var camera := get_viewport().get_camera_2d()
	var vp_size := get_viewport_rect().size / (camera.zoom if camera else Vector2(1, 1))
	var sprite_size := sprite.texture.get_size()
	var size: Vector2 = sprite_size * ceil(vp_size / sprite_size)
	
	sprite.region_rect.size = size
	repeat_size = size
