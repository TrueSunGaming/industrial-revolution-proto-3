class_name Filter extends Resource

enum {
	WHITELIST,
	BLACKLIST
}

@export var filters: Array[StringName]
@export var mode := WHITELIST

func check(key: StringName) -> bool:
	match mode:
		WHITELIST: return filters.has(key)
		BLACKLIST: return not filters.has(key)
		_: return false
