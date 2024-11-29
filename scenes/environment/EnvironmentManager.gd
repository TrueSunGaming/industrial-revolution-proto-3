class_name EnvironmentManager extends Node2D

@export var fallback_env: StringName

var active_env: Node2D
var active_env_id: StringName
var env_id: StringName:
	set(val):
		env_id = val
		reload_env()

func _ready() -> void:
	refs.env = self

func reload_env() -> void:
	save()
	
	if active_env: active_env.queue_free()
	
	var data := EnvironmentData.get_loaded(env_id)
	if not data:
		if env_id != fallback_env:
			OS.alert("Failed to load environment " + env_id + ".\nReverting to fallback environment " + fallback_env)
			env_id = fallback_env
			return
		
		OS.alert("Failed to load fallback environment " + fallback_env)
		return global.save_and_quit()
	
	refs.player.global_position = data.spawn_position
	active_env = data.scene.instantiate()
	active_env_id = env_id
	add_child(active_env)

func save() -> void:
	if not refs.save: return
	
	refs.save.last_environment = active_env_id
	if active_env and "save" in active_env and typeof(active_env.save) == TYPE_CALLABLE: active_env.save()
