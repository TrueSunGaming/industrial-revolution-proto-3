class_name ResourceData extends Resource

static var loaded: Dictionary[StringName, ResourceData]

enum ResourceType {
	SOLID,
	FLUID
}

@export var id: StringName:
	set(val):
		if id == val: return
		if id in loaded: loaded.erase(id)
		
		id = val
		loaded[id] = self

@export var name: String
@export_multiline var description: String
@export var texture: Texture2D
@export var color: Color
@export var type: ResourceType
@export var max_quantity = -1

static func get_loaded(id: StringName) -> ResourceData:
	return loaded.get(id)
