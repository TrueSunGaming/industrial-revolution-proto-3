class_name EntityTileMap extends LargeTileMap

var entities: Dictionary[Vector2i, TileEntity]
var entity_data: Dictionary[Vector2i, TileEntityData]

func place_tile(pos: Vector2i, id: StringName, centered := false, data_override: TileEntityData = null) -> bool:
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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released(): return handle_click(event)

func handle_click(event: InputEventMouseButton) -> void:
	var pos := get_tile_origin(local_to_map(get_local_mouse_position()))
	if not pos in entities: return attempt_place(pos)
	
	entities[pos].click(event)

func attempt_place(pos: Vector2i) -> bool:
	if not global.held_item: return false
	if global.held_item.quantity <= 0: return false
	if not global.held_item.resource_data: return false
	if global.held_item.resource_data.tile not in Tile.loaded: return false
	
	var res := place_tile(pos, global.held_item.resource_data.tile, true)
	
	global.held_item.quantity -= 1
	if global.held_item.quantity <= 0:
		refs.player.inventory.remove_index(global.held_item_index)
		global.return_held_item()
	
	return res
