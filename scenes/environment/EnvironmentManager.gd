class_name EnvironmentManager extends Node2D

var active_env: Node2D
var active_env_id: StringName
var env_id: StringName:
	set(val):
		env_id = val
		reload_env()

func _ready() -> void:
	refs.env = self

func reload_env() -> void:
	if active_env: active_env.queue_free()
	
	var data := EnvironmentData.get_data(env_id)
	if not data:
		OS.alert("Failed to load environment " + env_id)
		return global.save_and_quit()
	
	refs.player.global_position = data.spawn_position
	active_env = data.scene.instantiate()
	active_env_id = env_id
	add_child(active_env)
