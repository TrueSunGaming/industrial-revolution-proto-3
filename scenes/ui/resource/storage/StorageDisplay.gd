class_name StorageDisplay extends GridContainer

const resource_display: PackedScene = preload("res://scenes/ui/resource/MenuResourceStackDisplay.tscn")

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

@export var fill_full_line := false

var fill_empty_target: int:
	get:
		if not fill_full_line: return fill_empty_until
		
		return columns * ceili((maxf(storage.get_content().size(), fill_empty_until) + 1) / columns)

func fill_empty() -> void:
	while fill_empty_target > get_child_count(): add_display(null)

func add_display(stack: ResourceStack) -> void:
	var node := resource_display.instantiate()
	node.stack = stack
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
	
	fill_empty()

func on_modified(index: int) -> void:
	(get_child(index) as MenuResourceStackDisplay).stack = storage.get_content()[index]

func on_fully_modified() -> void:
	for i in get_children():
		remove_child(i)
		i.queue_free()
	for i in storage.get_content(): add_display(i)
	
	fill_empty()
