class_name EntityTileMap extends LargeTileMap

var _placing := false

var entities: Dictionary[Vector2i, TileEntity]
var entity_data: Dictionary[Vector2i, TileEntityData]

func place_tile(pos: Vector2i, id: StringName, centered := false, data_override: TileEntityData = null) -> bool:
	var tile := Tile.get_loaded(id)
	
	if not set_if_not_occupied(pos, tile.atlas_id, centered): return false
	
	var origin := get_tile_origin(pos)
	clear_entity(origin, get_tile_size(tile.atlas_id))
	
	if not tile.entity_class: return true
	var entity: Variant = tile.entity_class.new()
	if entity is not TileEntity:
		assert(false, "Tile entity_class is not a TileEntity")
		return true
	
	(entity as TileEntity).origin = origin
	(entity as TileEntity).map = self
	(entity as TileEntity).add_to_map(data_override)
	
	return true

func clear_entity(pos: Vector2i, size: Vector2i) -> void:
	for x in size.x:
		for y in size.y:
			var offset := Vector2i(x, y)
			if offset == Vector2i.ZERO: continue
			
			entities.erase(pos + offset)
			entity_data.erase(pos + offset)

func load_save(loaded_data: SaveData) -> void:
	for i in loaded_data.factory_data.keys():
		place_tile(
			i,
			Tile.get_from_atlas_id(loaded_data.factory_data[i]).id,
			false,
			loaded_data.factory_entity_data.get(i)
		)

func _input(event: InputEvent) -> void:
	if _should_end_place(event): _placing = false

func _unhandled_input(event: InputEvent) -> void:
	if _should_start_place(event): _placing = true
	if event is InputEventMouseButton and event.is_released(): return handle_click(event)

func _process(delta: float) -> void:
	if _placing: attempt_place(local_to_map(get_local_mouse_position()))

static func _should_start_place(event: InputEvent) -> bool:
	return global.is_mouse_button(event, MOUSE_BUTTON_LEFT) and event.is_pressed()

static func _should_end_place(event: InputEvent) -> bool:
	return global.is_mouse_button(event, MOUSE_BUTTON_LEFT) and event.is_released()

func handle_click(event: InputEventMouseButton) -> void:
	var pos := get_hovered_tile_origin()
	
	match event.button_index:
		MOUSE_BUTTON_LEFT:
			if pos in entities: entities[pos].click(event)

func attempt_place(pos: Vector2i) -> bool:
	if not global.held_item: return false
	if global.held_item.quantity <= 0: return false
	if not global.held_item.resource_data: return false
	if global.held_item.resource_data.tile not in Tile.loaded: return false
	
	var res := place_tile(pos, global.held_item.resource_data.tile, true)
	if not res: return false
	
	global.held_item.quantity -= 1
	if global.held_item.quantity <= 0:
		refs.player.inventory.remove_index(global.held_item_index)
		global.return_held_item()
	
	return true
