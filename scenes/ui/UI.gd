class_name UI extends CanvasLayer

var gui_windows: Array[GUIWindow]

var gui_window_open: bool:
	get:
		return gui_windows.size() > 0

func _ready() -> void:
	refs.ui = self

func _on_child_entered_tree(node: Node) -> void:
	if node is GUIWindow: gui_windows.push_back(node)

func _on_child_exiting_tree(node: Node) -> void:
	if node in gui_windows: gui_windows.erase(node)
