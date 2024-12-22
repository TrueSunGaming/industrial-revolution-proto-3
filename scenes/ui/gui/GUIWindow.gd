class_name GUIWindow extends Control

signal closed

@export var title: String:
	set(val):
		if title == val: return
		title = val
		
		if _title_node: _title_node.text = title

var child_windows: Array[GUIWindow]
var parent_window: GUIWindow

var _drag_start: Vector2
var dragging := false

@onready var _title_node: Label = $PanelContainer/VBoxContainer/Navbar/NavbarContent/Title

func _ready() -> void:
	if title: _title_node.text = title

func close() -> void:
	queue_free()

func _on_tree_exiting() -> void:
	for i in child_windows:
		i.parent_window = null
		i.close()
	
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
	_drag_start = get_local_mouse_position() - $PanelContainer.position

func end_drag() -> void:
	dragging = false

func update_drag() -> void:
	$PanelContainer.position = get_local_mouse_position() - _drag_start
	$PanelContainer.global_position = $PanelContainer.global_position.clamp(Vector2.ZERO, get_viewport_rect().size - $PanelContainer.size)
