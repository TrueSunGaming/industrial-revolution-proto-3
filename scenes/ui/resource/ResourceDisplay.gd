class_name ResourceDisplay extends PanelContainer

signal resource_changed
signal quantity_changed

@export var stack: ResourceStack:
	set(val):
		if stack == val: return
		
		global.reconnect(quantity_changed, stack, val)
		global.reconnect(resource_changed, stack, val)
		
		stack = val
		
		quantity_changed.emit()
		resource_changed.emit()

func _on_resource_changed() -> void:
	if stack and stack.resource_data and stack.resource_data.texture:
		var img := stack.resource_data.texture.get_image()
		img.resize(32, 32, Image.INTERPOLATE_NEAREST)
		$MarginContainer/TextureRect.texture = ImageTexture.create_from_image(img)
		
		$CountDisplay.show()
		$MarginContainer/TextureRect.show()
	else:
		$CountDisplay.hide()
		$MarginContainer/TextureRect.hide()
