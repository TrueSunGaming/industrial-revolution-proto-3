class_name Tile extends Resource

static var loaded: Dictionary[StringName, Tile]
static var atlas_id_map: Dictionary[int, Tile]

@export var id: StringName:
	set(val):
		if id == val: return
		if id in loaded: loaded.erase(id)
		id = val
		loaded[id] = self

@export var atlas_id := -1:
	set(val):
		if atlas_id == val: return
		if atlas_id in atlas_id_map: atlas_id_map.erase(atlas_id)
		atlas_id = val
		atlas_id_map[atlas_id] = self

@export var name: String
@export var entity_class: GDScript

static func get_loaded(id: StringName) -> Tile:
	return loaded.get(id)

static func get_atlas_id(id: StringName) -> int:
	return get_loaded(id).atlas_id

static func get_from_atlas_id(id: int) -> Tile:
	return atlas_id_map.get(id)

static func get_tile_id(atlas_id: int) -> StringName:
	return get_from_atlas_id(atlas_id).id
