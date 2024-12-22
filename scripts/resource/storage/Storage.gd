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
		
		var qty_added := 0
		for i in val:
			if slots >= 0 and qty_added >= slots: break
			if not can_add(i): continue
			
			content.push_back(i)
			qty_added += 1
		
		fully_modified.emit()

var full: bool:
	get:
		return slots >= 0 and content.size() >= slots

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
		remaining -= content[i].add(remaining)
		modified.emit(i)
	
	while remaining > 0 and not full:
		var rs := ResourceStack.new(stack.resource_id, remaining)
		if rs.max_quantity <= 0: break
		content.push_back(rs)
		appended.emit()
		remaining -= rs.quantity
	
	return stack.quantity - remaining

func remove(stack: ResourceStack) -> int:
	var remaining := stack.quantity
	
	var remove_count := 0
	for i in content.size():
		if remaining <= 0: break
		
		var s := content[i - remove_count]
		if s.resource_id != stack.resource_id: continue
		if s.quantity > 0:
			remaining -= s.remove(remaining)
			modified.emit(i)
		
		if remove_empty and s.quantity <= 0:
			content.remove_at(i)
			removed.emit(i)
	
	return stack.quantity - remaining
