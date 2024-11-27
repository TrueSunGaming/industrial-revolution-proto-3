class_name SaveData extends Serializable

func make_active() -> void:
	global.save = self

func _load_err(msg: String, path: String) -> bool:
	OS.alert(msg, "Failed to load save from " + path)
	return false

func load_from(path: String) -> bool:
	var json := JSON.new()
	var err := json.parse(FileAccess.open(path, FileAccess.READ).get_as_text())
	
	if err != OK: return _load_err(json.get_error_message() + " at line " + str(json.get_error_line()), path)
	if typeof(json.data) != TYPE_OBJECT: return _load_err("Parsed JSON data is not an object.", path)
	
	return true
