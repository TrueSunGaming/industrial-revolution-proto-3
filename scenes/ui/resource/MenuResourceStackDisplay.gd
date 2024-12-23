class_name MenuResourceStackDisplay extends PanelContainer

signal grabbed(event)

@export var stack: ResourceStack:
	set(val):
		if stack == val: return
		stack = val
		$ResourceStackDisplay.stack = val

func _gui_input(event: InputEvent) -> void:
	if not global.held_item and event is InputEventMouseButton and event.is_released():
		grabbed.emit(event)
		(event as InputEventMouseButton).canceled = true
		print("grabbed")
