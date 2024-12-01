class_name FluidData extends Resource

static var loaded: Dictionary[StringName, FluidData]

@export var id: StringName
@export var name: String
@export_multiline var description: String
@export_color_no_alpha var color: Color

static func get_loaded(id: StringName) -> FluidData:
	return loaded.get(id)
