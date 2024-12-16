class_name Main extends Node2D

func _ready() -> void:
	refs.main = self
	
	SaveData.load_from("user://save.tres").make_active()
	
	refs.env.env_id = refs.save.last_environment
	refs.player.inventory = Storage.new()
	refs.player.inventory.content = refs.save.player_inventory

func _process(delta: float) -> void:
	(refs.ui.get_node("StorageDisplay") as StorageDisplay).storage.add(ResourceStack.new(&"assembler_1", 1))
