class_name Storage extends StorageAccess

@export var allow_solids: bool
@export var allow_fluids: bool
@export var content: Array[ResourceStack]
@export var slots: int
@export var filter := Filter.ALL
@export var remove_empty := true

var full: bool:
	get:
		return slots >= 0 and content.size() >= slots

func can_add(stack: ResourceStack) -> bool:
	return filter.check(stack.resource_id)

func add(stack: ResourceStack) -> int:
	if not can_add(stack): return 0
	
	var remaining := stack.quantity
	
	for i in content:
		if remaining <= 0: break
		if i.resource_id != stack.resource_id: continue
		remaining -= i.add(remaining)
	
	while remaining > 0 and not full:
		var rs := ResourceStack.new(stack.resource_id, remaining)
		if rs.max_quantity <= 0: break
		content.push_back(rs)
		remaining -= rs.quantity
	
	return stack.quantity - remaining

func remove(stack: ResourceStack) -> int:
	var remaining := stack.quantity
	
	for i in content:
		if remaining <= 0: break
		if i.resource_id != stack.resource_id: continue
		if i.quantity > 0: remaining -= i.remove(remaining)
		
		if remove_empty and i.quantity <= 0: content.erase(i)
	
	return stack.quantity - remaining
