class_name CountDisplay extends Control

const roboto: FontFile = preload("res://fonts/Roboto-Light.ttf")

@onready var resource_display: ResourceDisplay = $".."

func _draw() -> void:
	if not resource_display: return
	if not resource_display.stack: return
	
	draw_string(roboto, resource_display.size - Vector2(roboto.get_string_size(str(resource_display.stack.quantity)).x, 0) - Vector2(5, 5), str(resource_display.stack.quantity))

func _on_resource_display_quantity_changed() -> void:
	queue_redraw()
