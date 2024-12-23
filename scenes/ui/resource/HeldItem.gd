class_name HeldItem extends ResourceStackDisplay

func _ready() -> void:
	global.held_item_changed.connect(func (_s: StorageAccess, _i: int): stack = global.held_item)

func _process(delta: float) -> void:
	global_position = get_global_mouse_position() - size / 2
