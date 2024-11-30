class_name SaveData extends Resource

var path: String

@export var last_environment: StringName = "factory"
@export var factory_data: Dictionary[Vector2i, int] = {}

func make_active() -> void:
	refs.save = self

static func load_from(path: String) -> SaveData:
	var obj: SaveData = ResourceLoader.load(path, "SaveData")
	if not obj: obj = SaveData.new()
	
	obj.path = path
	return obj

func save() -> void:
	var err := ResourceSaver.save(self, path)
	if err != OK:
		OS.alert("Failed to save game: " + str(err))
	else:
		print("Game saved")
