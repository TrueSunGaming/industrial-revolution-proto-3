class_name Factory extends Node2D

func _ready() -> void:
	$EntityTileMap.place_tile(Vector2i.ZERO, "assembler_1")
	
	$EntityTileMap.load_save(refs.save)

func save() -> void:
	refs.save.factory_data = $EntityTileMap.save_data
	refs.save.factory_entity_data = $EntityTileMap.entity_data
