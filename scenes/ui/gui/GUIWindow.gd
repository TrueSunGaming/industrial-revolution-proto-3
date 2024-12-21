class_name GUIWindow extends Control

signal closed

var child_windows: Array[GUIWindow]
var parent_window: GUIWindow

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
