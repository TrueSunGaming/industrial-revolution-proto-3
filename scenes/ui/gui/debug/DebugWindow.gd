extends GUIWindow

func _on_give_resource_pressed() -> void:
	var id: String = $PanelContainer/VBoxContainer/GiveResource/ResourceID.text
	var qty := int($PanelContainer/VBoxContainer/GiveResource/Quantity.text)
	refs.player.inventory.add(ResourceStack.new(id, qty, true))
