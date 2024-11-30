class_name Factory extends Node2D

func _ready() -> void:
	$LargeTileMap.set_large_tile(Vector2i.ZERO, 0)
	
	$LargeTileMap.load_save(refs.save.factory_data)

func save() -> void:
	refs.save.factory_data = $LargeTileMap.save_data
