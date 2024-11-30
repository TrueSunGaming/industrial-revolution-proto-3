class_name Filter extends Resource

enum {
	WHITELIST,
	BLACKLIST
}

@export var filters: Array[StringName]
@export var mode := BLACKLIST

func _init(mode := BLACKLIST, filters: Array[StringName] = []) -> void:
	self.mode = mode
	self.filters = filters

func check(key: StringName) -> bool:
	match mode:
		WHITELIST: return filters.has(key)
		BLACKLIST: return not filters.has(key)
		_: return false