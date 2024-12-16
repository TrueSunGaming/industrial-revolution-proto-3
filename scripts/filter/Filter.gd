class_name Filter extends Resource

enum Mode {
	WHITELIST,
	BLACKLIST
}

@export var filters: Array[StringName]
@export var mode := Mode.BLACKLIST

static var ALL: Filter:
	get:
		return Filter.new(Mode.BLACKLIST, [])

static var NONE: Filter:
	get:
		return Filter.new(Mode.WHITELIST, [])

func _init(mode := Mode.BLACKLIST, filters: Array[StringName] = []) -> void:
	self.mode = mode
	self.filters = filters

func check(key: StringName) -> bool:
	match mode:
		Mode.WHITELIST: return filters.has(key)
		Mode.BLACKLIST: return not filters.has(key)
		_: return false
