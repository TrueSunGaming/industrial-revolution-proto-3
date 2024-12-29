class_name LootTable extends Resource

@export var weights: Dictionary[StringName, float]

func _init(value_weights: Dictionary[StringName, float] = {}) -> void:
	weights = value_weights

func choose(count := 1) -> Array[StringName]:
	if weights.is_empty():
		push_error("LootTable weights is empty")
		return []
	
	var values := weights.keys()
	var cumulative_weights: Array[float] = []
	cumulative_weights.resize(weights.size())
	
	var index := 0
	for i in weights.values():
		cumulative_weights[index] = i + (cumulative_weights[index - 1] if index > 0 else 0)
		index += 1
	
	var res: Array[StringName] = []
	for i in count:
		var random := randf_range(0, cumulative_weights.back())
		res.push_back(values[global.find_next_after(cumulative_weights, random)])
	
	return res
