class_name Main extends Node2D

func _ready() -> void:
	refs.main = self
	
	SaveData.load_from("user://save.tres").make_active()
	
	refs.env.env_id = refs.save.last_environment
	refs.player.inventory = ItemInventory.new(60)
	refs.player.inventory.items = refs.save.player_inventory
