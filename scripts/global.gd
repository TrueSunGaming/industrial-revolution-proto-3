extends Node

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
