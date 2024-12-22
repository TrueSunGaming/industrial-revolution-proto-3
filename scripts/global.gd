extends Node

signal held_item_changed

var held_item_storage: StorageAccess:
	set(val):
		if held_item_storage == val: return
		held_item_storage = val
		
		held_item_changed.emit()

var held_item_index: int:
	set(val):
		if held_item_index == val: return
		held_item_index = val
		
		held_item_changed.emit()

var held_item: ResourceStack:
	get:
		if held_item_index < 0: return null
		if not held_item_storage: return null
		
		var content := held_item_storage.get_content()
		if held_item_index >= content.size(): return null
		
		return content[held_item_index]

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)

func save_and_quit() -> void:
	if refs.save:
		if refs.env: refs.env.save()
		if refs.player: refs.player.save()
		
		refs.save.save()
	
	get_tree().quit()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST: save_and_quit()

func safe_disconnect(sig: Signal, fn: Callable) -> void:
	if sig.is_connected(fn): sig.disconnect(fn)

func reconnect(sig: Callable, from: Object, to: Object, sig_name: String) -> void:
	if from and sig_name in from and from[sig_name] is Signal:
		safe_disconnect(from[sig_name], sig)
	
	if to and sig_name in to and to[sig_name] is Signal:
		to[sig_name].connect(sig)

func _input(event: InputEvent) -> void:
	if not held_item and Input.is_action_just_released("pipette"): return pipette()
	elif held_item and Input.is_action_just_released("return_held_item"): return return_held_item()

func pipette() -> void:
	pass

func return_held_item() -> void:
	if held_item_storage != refs.player.inventory:
		var item := held_item
		held_item_storage.remove_index(held_item_index)
		refs.player.inventory.add(item)
	
	held_item_storage = null
	held_item_index = -1
