class_name MenuResourceStackDisplay extends PanelContainer

signal grabbed

@export var stack: ResourceStack:
	set(val):
		if stack == val: return
		stack = val
		$ResourceStackDisplay.stack = val

@export var in_hand: bool:
	set(val):
		if in_hand == val: return
		in_hand = val
		$ResourceStackDisplay.in_hand = val

func _gui_input(event: InputEvent) -> void:
	if stack and not global.held_item and event is InputEventMouseButton and event.is_released():
		grabbed.emit()
		(event as InputEventMouseButton).canceled = true
