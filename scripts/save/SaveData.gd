class_name SaveData extends Resource

@export var path: String

@export var last_environment := "factory"

func make_active() -> void:
	refs.save = self

static func load_from(path: String) -> SaveData:
	var obj: SaveData = ResourceLoader.load(path, "SaveData")
	obj.path = path
	return obj

func save() -> void:
	ResourceSaver.save(self, path)

func save_and_quit() -> void:
	save()
	global.get_tree().quit()
