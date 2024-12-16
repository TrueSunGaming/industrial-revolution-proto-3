class_name ResourceDisplay extends PanelContainer

signal resource_changed
signal quantity_changed

@export var stack: ResourceStack:
	set(val):
		if stack == val: return
		
		if stack:
			if stack.quantity_changed.is_connected(quantity_changed.emit):
				stack.quantity_changed.disconnect(quantity_changed.emit)
			
			if stack.resource_changed.is_connected(resource_changed.emit):
				stack.resource_changed.disconnect(resource_changed.emit)
		
		stack = val
		stack.quantity_changed.connect(quantity_changed.emit)
		stack.resource_changed.connect(resource_changed.emit)
		
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
