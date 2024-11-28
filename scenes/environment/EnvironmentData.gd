class_name EnvironmentData extends Resource

static var loaded: Dictionary[StringName, EnvironmentData]

@export var id: StringName:
	set(val):
		id = val
		loaded[id] = self
@export var scene: PackedScene
@export var default_spawn_position: Vector2
@export var travel_spawn_positions: Dictionary[StringName, Vector2]

var spawn_position: Vector2:
	get:
		if refs.env.active_env_id in travel_spawn_positions: return travel_spawn_positions[refs.env.active_env_id]
		
		return default_spawn_position

static func get_loaded(id: StringName) -> EnvironmentData:
	return loaded.get(id)
