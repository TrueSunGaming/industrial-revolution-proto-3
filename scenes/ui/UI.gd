class_name UI extends CanvasLayer

var gui_windows: Array[GUIWindow]

var gui_window_open: bool:
	get:
		return gui_windows.size() > 0

var focused: bool:
	get:
		var focus_owner := get_viewport().gui_get_focus_owner()
		if not focus_owner: return false
		if focus_owner is LineEdit: return true
		if focus_owner is TextEdit: return true
		
		return false

func _ready() -> void:
	refs.ui = self

func _on_child_entered_tree(node: Node) -> void:
	if node is GUIWindow: gui_windows.push_back(node)

func _on_child_exiting_tree(node: Node) -> void:
	if node in gui_windows: gui_windows.erase(node)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("open_inventory") and not focused:
		if gui_window_open: for i in gui_windows:
			i.close()
		else: add_child(loads.player_inventory_gui.instantiate())
	
	if Input.is_action_just_pressed("debug_button") and OS.is_debug_build():
		add_child(loads.debug_gui.instantiate())
