class_name EntityTileMap extends LargeTileMap

var entities: Dictionary[Vector2i, TileEntity]
var entity_data: Dictionary[Vector2i, Resource]

func place_tile(pos: Vector2i, id: StringName, centered := false, data_override: Resource = null) -> bool:
	var tile := Tile.get_loaded(id)
	
	if not set_if_not_occupied(pos, tile.atlas_id, centered): return false
	
	if not tile.entity_class: return true
	var entity: Variant = tile.entity_class.new()
	if entity is not TileEntity:
		assert(false, "Tile entity_class is not a TileEntity")
		return true
	
	(entity as TileEntity).origin = get_tile_origin(pos)
	(entity as TileEntity).map = self
	(entity as TileEntity).add_to_map(data_override)
	
	return true

func load_save(loaded_data: SaveData) -> void:
	for i in loaded_data.factory_data.keys():
		place_tile(
			i,
			Tile.get_from_atlas_id(loaded_data.factory_data[i]).id,
			false,
			loaded_data.factory_entity_data.get(i)
		)
