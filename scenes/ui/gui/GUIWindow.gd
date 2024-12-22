class_name GUIWindow extends Control

signal closed

var child_windows: Array[GUIWindow]
var parent_window: GUIWindow

var _drag_start: Vector2
var dragging := false

func _on_close_pressed() -> void:
	queue_free()

func _on_tree_exiting() -> void:
	for i in child_windows:
		i.parent_window = null
		i._on_close_pressed()
	
	closed.emit()

func add_child_window(win: GUIWindow) -> void:
	child_windows.push_back(win)
	win.parent_window = self

func _on_navbar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed(): begin_drag()
		else: end_drag()
	
	if event is InputEventMouseMotion and dragging: update_drag()

func begin_drag() -> void:
	dragging = true
	_drag_start = get_local_mouse_position()

func end_drag() -> void:
	dragging = false

func update_drag() -> void:
	var pos := get_local_mouse_position()
	$PanelContainer.position += pos - _drag_start
	_drag_start = pos
