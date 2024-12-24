class_name Tile extends Resource

static var loaded: Dictionary[StringName, Tile]

@export var id: StringName:
	set(val):
		if id == val: return
		if id in loaded: loaded.erase(id)
		id = val
		loaded[id] = self

@export var atlas_id: int
@export var name: String
@export var entity_class: Script

static func get_loaded(id: StringName) -> Tile:
	return loaded.get(id)

static func get_atlas_id(id: StringName) -> int:
	return get_loaded(id).atlas_id
