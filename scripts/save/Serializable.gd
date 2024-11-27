class_name Serializable extends Resource

func _throw(msg: String) -> bool:
	OS.alert(msg, "Failed to deserialize JSON")
	return false

func serialize() -> String:
	return ""

func deserialize(str: String) -> bool:
	return false
