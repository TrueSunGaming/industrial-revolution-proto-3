extends StorageDisplay

func _ready() -> void:
	storage = refs.player.inventory
	(storage as Storage).capacity_changed.connect(update_empty_slots)
	update_empty_slots()

func update_empty_slots() -> void:
	fill_empty_until = (storage as Storage).slots
