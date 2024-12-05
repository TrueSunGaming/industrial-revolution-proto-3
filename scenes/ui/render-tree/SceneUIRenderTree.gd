class_name SceneUIRenderTree extends UIRenderTree

@export var scene: PackedScene

func create_node() -> Control:
	return scene.instantiate()
