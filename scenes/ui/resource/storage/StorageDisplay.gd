class_name StorageDisplay extends GridContainer

const resource_display: PackedScene = preload("res://scenes/ui/resource/MenuResourceStackDisplay.tscn")

signal node_removed(idx)

@export var storage: StorageAccess:
	set(val):
		if storage == val: return
		
		global.reconnect(on_appended, storage, val, "appended")
		global.reconnect(on_removed, storage, val, "removed")
		global.reconnect(on_modified, storage, val, "modified")
		global.reconnect(on_fully_modified, storage, val, "fully_modified")
		
		storage = val
		
		on_fully_modified()

@export var fill_empty_until := 0:
	set(val):
		if fill_empty_until == val: return
		fill_empty_until = val
		
		fill_empty()

@export var fill_full_line := false:
	set(val):
		if fill_full_line == val: return
		fill_full_line = val
		
		fill_empty()

var fill_empty_target: int:
	get:
		if not fill_full_line: return fill_empty_until
		
		return columns * ceili(maxf((storage.get_content() if storage else []).size() + 1, fill_empty_until) / columns)

func fill_empty() -> void:
	while fill_empty_target > get_child_count(): add_display(null)

func add_display(stack: ResourceStack) -> void:
	var node := resource_display.instantiate()
	node.stack = stack
	node.grabbed.connect(func (): grab_item(get_children().find(node)))
	
	add_child(node)

func on_appended() -> void:
	fill_empty()
	
	var content := storage.get_content()
	if content.size() - 1 < fill_empty_target: return on_modified(content.size() - 1)
	
	add_display(content.back())

func on_removed(index: int) -> void:
	var node := get_child(index)
	remove_child(node)
	node.queue_free()
	node_removed.emit(index)
	
	fill_empty()

func on_modified(index: int) -> void:
	(get_child(index) as MenuResourceStackDisplay).stack = storage.get_content()[index]

func on_fully_modified() -> void:
	for i in get_children():
		remove_child(i)
		i.queue_free()
	for i in storage.get_content(): add_display(i)
	
	fill_empty()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		if global.held_item: match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_LEFT:
				if Input.is_key_pressed(KEY_SHIFT): return transfer_max_held_item()
				return transfer_held_item()
			
			MOUSE_BUTTON_RIGHT: return transfer_half_held_item()
			MOUSE_BUTTON_MIDDLE: return transfer_one_held_item()

func transfer_held_item() -> void:
	global.transfer_held_item(storage)

func transfer_half_held_item() -> void:
	pass

func transfer_one_held_item() -> void:
	pass

func transfer_max_held_item() -> void:
	pass

func grab_item(idx: int) -> void:
	global.held_item_storage = storage
	global.held_item_index = idx
