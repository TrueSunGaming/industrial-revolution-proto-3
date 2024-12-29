class_name TileEntity extends RefCounted

var map: EntityTileMap:
	set(val):
		if map == val: return
		map = val
		_update_atlas_id()

var origin: Vector2i:
	set(val):
		if origin == val: return
		origin = val
		_update_atlas_id()

var atlas_id: int
var tile: Tile

func _update_atlas_id() -> void:
	var old := atlas_id
	atlas_id = map.get_cell_source_id(origin) if map else -1
	if atlas_id != old: _update_tile()

func _update_tile() -> void:
	tile = Tile.get_from_atlas_id(atlas_id)

func _init() -> void:
	_update_atlas_id()

func tick(delta: float) -> void:
	pass

func click(event: InputEventMouseButton) -> void:
	pass

func create_data() -> TileEntityData:
	return null

func add_to_map(data_override: TileEntityData = null) -> void:
	if not map: return push_warning("Could not add TileEntity to map. map is null")
	
	map.entities[origin] = self
	var entity_data := data_override if data_override else create_data()
	if entity_data: map.entity_data[origin] = entity_data
