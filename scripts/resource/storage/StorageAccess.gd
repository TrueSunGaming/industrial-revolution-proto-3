class_name StorageAccess extends Resource

signal appended
signal removed(index)
signal modified(index)
signal fully_modified

func get_content() -> Array[ResourceStack]:
	assert(false, "StorageAccess.get_content is abstract.")
	return []

func add(stack: ResourceStack) -> int:
	assert(false, "StorageAccess.add is abstract.")
	return 0

func remove(stack: ResourceStack) -> int:
	assert(false, "StorageAccess.remove is abstract.")
	return 0
