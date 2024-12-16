class_name StorageDisplay extends GridContainer

const resource_display: PackedScene = preload("res://scenes/ui/resource/ResourceDisplay.tscn")

@export var storage: StorageAccess:
	set(val):
		if storage == val: return
		
		if storage:
			global.safe_disconnect(storage.appended, on_appended)
			global.safe_disconnect(storage.removed, on_removed)
			global.safe_disconnect(storage.modified, on_modified)
			global.safe_disconnect(storage.fully_modified, on_fully_modified)
		
		storage = val
		
		storage.appended.connect(on_appended)
		storage.removed.connect(on_removed)
		storage.modified.connect(on_modified)
		storage.fully_modified.connect(on_fully_modified)
		
		on_fully_modified()

@export var fill_empty_until := 0:
	set(val):
		if fill_empty_until == val: return
		fill_empty_until = val
		
		fill_empty()

func fill_empty() -> void:
	while fill_empty_until > get_child_count(): add_display(null)

func add_display(stack: ResourceStack) -> void:
	var node := resource_display.instantiate()
	node.stack = stack
	add_child(node)

func on_appended() -> void:
	var content := storage.get_content()
	if content.size() - 1 < fill_empty_until: return on_modified(content.size() - 1)
	
	add_display(content.back())

func on_removed(index: int) -> void:
	var node := get_child(index)
	remove_child(node)
	node.queue_free()
	
	fill_empty()

func on_modified(index: int) -> void:
	(get_child(index) as ResourceDisplay).stack = storage.get_content()[index]

func on_fully_modified() -> void:
	for i in get_children(): i.queue_free()
	for i in storage.get_content(): add_display(i)
	
	fill_empty()
