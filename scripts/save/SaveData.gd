class_name SaveData extends Resource

func make_active() -> void:
	global.save = self

static func load_from(path: String) -> SaveData:
	return ResourceLoader.load(path, "SaveData")

func save_to(path: String) -> void:
	ResourceSaver.save(self, path)
