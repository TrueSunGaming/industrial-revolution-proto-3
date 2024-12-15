class_name IOStorage extends StorageAccess

@export var input: StorageAccess
@export var output: StorageAccess

func add(stack: ResourceStack) -> int:
	return input.add(stack)

func remove(stack: ResourceStack) -> int:
	return output.remove(stack)
