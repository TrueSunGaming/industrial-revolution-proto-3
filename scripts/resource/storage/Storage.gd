class_name Storage extends StorageAccess

signal capacity_changed

@export var allow_solids := true
@export var allow_fluids := true
@export var filter := Filter.ALL
@export var remove_empty := true

@export var slots := -1:
	set(val):
		if slots == val: return
		slots = val
		capacity_changed.emit()

@export var content: Array[ResourceStack]:
	set(val):
		if content == val: return
		content = []
		counts.clear()
		
		var qty_added := 0
		for i in val:
			if slots >= 0 and qty_added >= slots: break
			if not can_add(i): continue
			
			if i.resource_id not in counts: counts[i.resource_id] = 0
			counts[i.resource_id] += i.quantity
			
			content.push_back(i)
			qty_added += 1
		
		fully_modified.emit()

var full: bool:
	get:
		return slots >= 0 and content.size() >= slots

var counts: Dictionary[StringName, int]

func get_content() -> Array[ResourceStack]:
	return content

func can_add(stack: ResourceStack) -> bool:
	if stack.resource_data.type == ResourceData.ResourceType.SOLID and not allow_solids: return false
	if stack.resource_data.type == ResourceData.ResourceType.FLUID and not allow_fluids: return false
	if not filter.check(stack.resource_id): return false
	
	return true

func add(stack: ResourceStack) -> int:
	if not can_add(stack): return 0
	
	var remaining := stack.quantity
	
	for i in content.size():
		if remaining <= 0: break
		if content[i].resource_id != stack.resource_id: continue
		
		var added := content[i].add(remaining)
		counts[stack.resource_id] += added
		remaining -= added
		
		modified.emit(i)
	
	while remaining > 0 and not full:
		var rs := ResourceStack.new(stack.resource_id, remaining)
		if rs.max_quantity <= 0: break
		
		if stack.resource_id not in counts: counts[stack.resource_id] = 0
		counts[stack.resource_id] += rs.quantity
		remaining -= rs.quantity
		
		content.push_back(rs)
		appended.emit()
	
	return stack.quantity - remaining

func remove(stack: ResourceStack) -> int:
	var remaining := stack.quantity
	
	var remove_count := 0
	for i in content.size():
		if remaining <= 0: break
		
		var s := content[i - remove_count]
		if s.resource_id != stack.resource_id: continue
		if s.quantity > 0:
			var removed := s.remove(remaining)
			remaining -= removed
			counts[stack.resource_id] -= removed
			modified.emit(i)
		
		if remove_empty and s.quantity <= 0:
			content.remove_at(i)
			removed.emit(i)
	
	return stack.quantity - remaining

func remove_index(idx: int) -> bool:
	if idx < 0: return false
	if idx >= content.size(): return false
	
	counts[content[idx].resource_id] -= content[idx].quantity
	content.remove_at(idx)
	removed.emit(idx)
	
	return true

func craft(recipe_id: StringName, count := 1) -> bool:
	if not can_craft(recipe_id, count): return false
	
	var recipe := Recipe.get_loaded(recipe_id)
	for i in recipe.ingredients: remove(ResourceStack.new(i.resource_id, i.quantity * count, true))
	for i in recipe.products: add(ResourceStack.new(i.resource_id, i.quantity * count, true))
	
	return true

func can_hold_product(recipe_id: StringName, count := 1) -> bool:
	var slots_taken := 0
	
	for i in Recipe.get_loaded(recipe_id).products:
		if not filter.check(i.resource_id): return false
		if slots < 0: continue
		
		var remaining := i.quantity * count
		
		for j in content:
			if remaining <= 0: break
			if j.resource_id != i.resource_id: continue
			remaining -= i.max_quantity - i.quantity
		
		if remaining <= 0: continue
		
		if (slots - content.size() - slots_taken) * i.resource_data.max_quantity < remaining: return false
		else: slots_taken += ceili(float(i.resource_data.max_quantity) / remaining)
	
	return true

func can_craft(recipe_id: StringName, count := 1) -> bool:
	if not can_hold_product(recipe_id, count): return false
	
	for i in Recipe.get_loaded(recipe_id).ingredients:
		if i.resource_id not in counts: return false
		if counts[i.resource_id] < i.quantity * count: return false
	
	return false
