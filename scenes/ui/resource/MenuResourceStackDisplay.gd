class_name MenuResourceStackDisplay extends PanelContainer

@export var stack: ResourceStack:
	set(val):
		if stack == val: return
		stack = val
		$ResourceStackDisplay.stack = val
