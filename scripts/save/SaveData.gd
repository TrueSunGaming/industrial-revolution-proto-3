class_name SaveData extends Resource

@export var path: String

func make_active() -> void:
	global.save = self

static func load_from(path: String) -> SaveData:
	var obj: SaveData = ResourceLoader.load(path, "SaveData")
	obj.path = path
	return obj

func save() -> void:
	ResourceSaver.save(self, path)
