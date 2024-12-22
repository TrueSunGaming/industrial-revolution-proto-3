extends GUIWindow

func _on_give_resource_pressed() -> void:
	var id: String = $PanelContainer/VBoxContainer/ContentMargin/Content/GiveResource/ResourceID.text
	var qty := int($PanelContainer/VBoxContainer/ContentMargin/Content/GiveResource/Quantity.text)
	refs.player.inventory.add(ResourceStack.new(id, qty, true))

func _on_wipe_inventory_pressed() -> void:
	refs.player.inventory.content = []

func _on_set_hand_pressed() -> void:
	global.held_item_storage = refs.player.inventory
	global.held_item_index = int($PanelContainer/VBoxContainer/ContentMargin/Content/SetHand/Index.text)
