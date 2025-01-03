extends Node

signal held_item_changed(last_storage, last_index)

var held_item_storage: StorageAccess:
	set(val):
		if held_item_storage == val: return
		var last := held_item_storage
		held_item_storage = val
		
		held_item_changed.emit(last, held_item_index)

var held_item_index: int:
	set(val):
		if held_item_index == val: return
		var last := held_item_index
		held_item_index = val
		
		held_item_changed.emit(held_item_storage, last)

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

static func safe_disconnect(sig: Signal, fn: Callable) -> void:
	if sig.is_connected(fn): sig.disconnect(fn)

static func reconnect(sig: Callable, from: Object, to: Object, sig_name: String) -> void:
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
	transfer_held_item(refs.player.inventory)

func transfer_held_item(to: StorageAccess) -> void:
	if held_item_storage != refs.player.inventory or to != refs.player.inventory:
		var item := held_item
		held_item_storage.remove_index(held_item_index)
		to.add(item)
	
	held_item_storage = null
	held_item_index = -1

static func find_next_after(arr: Array[float], limit: float) -> int:
	if arr.is_empty(): return -1
	if limit > arr.back(): return -1
	
	var left := 0
	var right := arr.size() - 1
	var mid := (left + right + 1) / 2
	
	while right != mid:
		if arr[mid] < limit: left = mid
		else: right = mid
		
		mid = (left + right + 1) / 2
	
	return right if arr[left] < limit else left

static func is_mouse_button(event: InputEvent, button: MouseButton) -> bool:
	return event is InputEventMouseButton and (event as InputEventMouseButton).button_index == button
