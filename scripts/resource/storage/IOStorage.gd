class_name IOStorage extends StorageAccess

@export var input: StorageAccess
@export var output: StorageAccess

func get_content() -> Array[ResourceStack]:
	var res: Array[ResourceStack] = input.get_content().duplicate()
	res.append_array(output.get_content())
	return res

func add(stack: ResourceStack) -> int:
	return input.add(stack)

func remove(stack: ResourceStack) -> int:
	return output.remove(stack)
