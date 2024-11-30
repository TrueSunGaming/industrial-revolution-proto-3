class_name ItemData extends Resource

static var loaded: Dictionary[StringName, ItemData]

@export var id: StringName
@export var name: String
@export_multiline var description: String
@export var stack_size: int
@export var texture: Texture2D

static func get_loaded(id: StringName) -> ItemData:
	return loaded.get(id)
