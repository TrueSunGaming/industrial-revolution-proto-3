extends StorageDisplay

func _ready() -> void:
	super._ready()
	storage = refs.player.inventory
	storage.appended.connect(update_panel_size)
	storage.removed.connect(update_panel_size)
	storage.fully_modified.connect(update_panel_size)
	(storage as Storage).capacity_changed.connect(update_empty_slots)
	update_empty_slots()

func update_empty_slots() -> void:
	fill_empty_until = (storage as Storage).slots
	update_panel_size()

func update_panel_size(_idx := 0) -> void:
	%PanelContainer.size = Vector2.ZERO
