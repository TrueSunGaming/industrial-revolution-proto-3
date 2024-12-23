class_name IOStorage extends StorageAccess

@export var input: StorageAccess
@export var output: StorageAccess

func get_content() -> Array[ResourceStack]:
	var res: Array[ResourceStack] = input.get_content().duplicate()
	res.append_array(output.get_content())
	return res

func add(stack: ResourceStack) -> int:
	return input.add(stack)

func remove(stack: ResourceStack) -> int:
	return output.remove(stack)

func remove_index(idx: int) -> bool:
	if idx < input.get_content().size(): return input.remove_index(idx)
	return output.remove_index(idx - input.get_content().size())

func craft(recipe_id: StringName, count := 1) -> bool:
	if not can_craft(recipe_id, count): return false
	
	var recipe := Recipe.get_loaded(recipe_id)
	for i in recipe.ingredients: input.remove(ResourceStack.new(i.resource_id, i.quantity * count, true))
	for i in recipe.products: output.add(ResourceStack.new(i.resource_id, i.quantity * count, true))
	
	return true

func can_hold_product(recipe_id: StringName, count := 1) -> bool:
	return output.can_hold_product(recipe_id, count)

func can_craft(recipe_id: StringName, count := 1, ignore_product := false) -> bool:
	if not ignore_product and not can_hold_product(recipe_id, count): return false
	return input.can_craft(recipe_id, count, true)
