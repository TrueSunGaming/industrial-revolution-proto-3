class_name LargeTileMap extends TileMapLayer

var _tileset_size_cache: Dictionary[int, Vector2i]

var save_data: Dictionary[Vector2i, int]:
	get:
		var res: Dictionary[Vector2i, int]
		
		for i in get_used_cells():
			if get_cell_atlas_coords(i) == Vector2i.ZERO: res[i] = get_cell_source_id(i)
		
		return res

func get_tile_size(id: int) -> Vector2i:
	if id == -1: return Vector2i(1, 1)
	if id in _tileset_size_cache: return _tileset_size_cache[id]
	
	var source := tile_set.get_source(id) as TileSetAtlasSource
	if not source: return Vector2i(1, 1)
	
	var size := Vector2i(source.texture.get_size()) / source.texture_region_size
	
	_tileset_size_cache[id] = size
	return size

func get_tile_origin(pos: Vector2i) -> Vector2i:
	var coords := get_cell_atlas_coords(pos)
	if coords == Vector2i(-1, -1): return pos
	
	var source := tile_set.get_source(get_cell_source_id(pos)) as TileSetAtlasSource
	var size := source.texture_region_size if source else tile_set.tile_size
	
	return pos - (coords * tile_set.tile_size) / size

func _set_large_tile_precomputed(pos: Vector2i, id: int, size: Vector2i) -> void:
	for x in range(size.x):
		for y in range(size.y):
			set_cell(Vector2i(pos.x + x, pos.y + y), id, Vector2i(x, y))

func set_large_tile(pos: Vector2i, id: int, centered := false) -> void:
	var size := get_tile_size(id)
	if centered: pos -= size / 2
	
	_set_large_tile_precomputed(pos, id, size)

func is_occupied(pos: Vector2i, size := Vector2i(1, 1), centered := false) -> bool:
	if centered: pos -= size / 2
	
	for x in range(pos.x, pos.x + size.x):
		for y in range(pos.y, pos.y + size.y):
			if get_cell_source_id(Vector2i(x, y)) != -1: return true
	
	return false

func can_set(pos: Vector2i, size := Vector2i(1, 1), centered := false) -> bool:
	return not is_occupied(pos, size, centered)

func can_set_id(pos: Vector2i, id: int, centered := false) -> bool:
	return can_set(pos, get_tile_size(id), centered)

func set_if_not_occupied(pos: Vector2i, id: int, centered := false) -> bool:
	var size := get_tile_size(id)
	
	if can_set(pos, size, centered):
		_set_large_tile_precomputed(pos, id, size)
		return true
	
	return false

func load_save(loaded_data: Dictionary[Vector2i, int]) -> void:
	for i in loaded_data.keys(): set_large_tile(i, loaded_data[i])
