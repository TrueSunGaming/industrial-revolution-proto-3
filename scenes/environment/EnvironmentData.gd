class_name EnvironmentData extends Resource

static var map: Dictionary[String, EnvironmentData]

@export var id: String:
	set(val):
		id = val
		map[id] = self
@export var scene: PackedScene
@export var default_spawn_position: Vector2
@export var travel_spawn_positions: Dictionary[String, Vector2]

var spawn_position: Vector2:
	get:
		if refs.env.active_env_id in travel_spawn_positions: return travel_spawn_positions[refs.env.active_env_id]
		
		return default_spawn_position

static func get_data(id: String) -> EnvironmentData:
	return map.get(id)
