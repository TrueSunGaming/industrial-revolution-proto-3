class_name UIRenderTree extends Resource

static var loaded: Dictionary[StringName, UIRenderTree]

@export var id: StringName:
	set(val):
		if id == val or len(val) == 0: return
		id = val
		loaded[id] = self

@export var children: Array[UIRenderTree]

func create_node() -> Control:
	return Control.new()

func assemble_node_tree(hidden := false) -> Control:
	var node := create_node()
	if hidden: node.hide()
	
	for i in children:
		node.add_child(i.assemble_node_tree())
	
	return node

func add_to_ui(hidden := false) -> void:
	refs.ui.add_child(assemble_node_tree(hidden))

static func get_loaded(id: StringName) -> UIRenderTree:
	return loaded.get(id)

static func add_loaded_to_ui(id: StringName, hidden := false) -> void:
	get_loaded(id).add_to_ui(hidden)
