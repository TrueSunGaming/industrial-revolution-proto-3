class_name HoverIndicator extends Node2D

var _tilemap: LargeTileMap

func _ready() -> void:
	var parent := get_parent()
	assert(parent is LargeTileMap, "HoverIndicator's parent must be a LargeTileMap")
	
	_tilemap = parent

func _process(delta: float) -> void:
	update()

func update() -> void:
	var mouse := _tilemap.local_to_map(_tilemap.get_local_mouse_position())
	position = _tilemap.map_to_local(_tilemap.get_tile_origin(mouse)) - Vector2(_tilemap.tile_set.tile_size) / 2
	
	var source := _tilemap.get_cell_source_id(mouse)
	if source < 0: return hide()
	
	var size := _tilemap.get_tile_size(source) * _tilemap.tile_set.tile_size
	
	$TopRight.position.x = size.x
	$BottomLeft.position.y = size.y
	$BottomRight.position = size
	show()
