class_name TileEntity extends RefCounted

var map: EntityTileMap
var origin: Vector2i

func tick(delta: float) -> void:
	pass

func create_data() -> Resource:
	return null

func add_to_map() -> void:
	if not map: return push_warning("Could not add TileEntity to map. map is null")
	
	map.entities[origin] = self
	var entity_data := create_data()
	if entity_data: map.entity_data[origin] = entity_data
	
	var size := map.get_tile_size(map.get_cell_source_id(origin))
	
	for x in size.x:
		for y in size.y:
			var pos := Vector2i(x, y)
			if pos == Vector2i.ZERO: continue
			
			map.entities.erase(pos)
			map.entity_data.erase(pos)
