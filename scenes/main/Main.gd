class_name Main extends Node2D

func _ready() -> void:
	refs.main = self
	
	SaveData.load_from("user://save.tres").make_active()
	
	refs.env.env_id = refs.save.last_environment
