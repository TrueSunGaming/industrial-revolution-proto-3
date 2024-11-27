class_name EnvironmentManager extends Node2D

var active_env: Node2D
var active_env_scene: PackedScene

func _ready() -> void:
	refs.env = self

func set_env(scene: PackedScene) -> void:
	active_env_scene = scene
	
	reload_env()

func reload_env() -> void:
	if active_env: active_env.queue_free()
	
	active_env = active_env_scene.instantiate()
	add_child(active_env)
