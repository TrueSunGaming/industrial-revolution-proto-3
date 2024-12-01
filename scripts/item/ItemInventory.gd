class_name ItemInventory extends Resource

@export var items: Dictionary[int, ItemStack]:
	set(val):
		if items == val: return
		items = val
		
		reload_item_quantities()

@export var filtered_slots: Dictionary[int, Filter]
@export var small_slots: Dictionary[int, int]:
	set(val):
		if small_slots == val: return
		small_slots = val
		
		reload_small_slots()

@export var capacity := -1
@export var filter := Filter.ALL

var item_quantities: Dictionary[StringName, int]

func _init(capacity := -1, filter := Filter.ALL) -> void:
	self.capacity = capacity
	self.filter = filter

func reload_item_quantities() -> void:
	item_quantities = {}
	for i: ItemStack in items.values():
		item_quantities[i.item_id] = i.count + (item_quantities[i.item_id] if i.item_id in item_quantities else 0)

func reload_small_slot(pos: int) -> void:
	items[pos].stack_size_override = small_slots[pos] if pos in small_slots else -1

func reload_small_slots() -> void:
	for i in items.keys(): reload_small_slot(i)

func clear_blank() -> void:
	for i in items.keys():
		if items[i].empty: items.erase(i)

func can_insert_at(position: int, item_id: StringName) -> bool:
	var filter_valid := filtered_slots[position].check(item_id) if position in filtered_slots else true
	
	if position not in items: return filter_valid
	return filter_valid and not items[position].full and item_id == items[position].item_id

func get_insert_position(item_id: StringName) -> int:
	for i in filtered_slots.keys():
		if can_insert_at(i, item_id): return i
	
	var position := 0
	while capacity < 0 or position < capacity:
		if position in filtered_slots: continue
		if can_insert_at(position, item_id): return position
		position += 1
	
	return -1

func add_item(item_id: StringName, count: int) -> int:
	if not filter.check(item_id): return 0
	
	var remaining := count
	
	while remaining > 0:
		var pos = get_insert_position(item_id)
		if pos < 0: break
		if pos not in items:
			items[pos] = ItemStack.new(item_id)
			reload_small_slot(pos)
		
		remaining -= items[pos].give(remaining)
	
	var added := count - remaining
	
	if added > 0: item_quantities[item_id] = added + (item_quantities[item_id] if item_id in item_quantities else 0)
	return added

func add_item_stack(stack: ItemStack) -> int:
	return add_item(stack.item_id, stack.count)

func add_item_stacks(stacks: Array[ItemStack]) -> Array[int]:
	return stacks.map(func (v): return add_item_stack(v))

func take_from_item_stack(stack: ItemStack) -> void:
	var added := add_item_stack(stack)
	var taken := stack.take(added)
	assert(taken == added, "Unexpected low stack.count in take_from_item_stack")

func take_from_item_stacks(stacks: Array[ItemStack]) -> void:
	for i in stacks: take_from_item_stack(i)

func remove_item(item_id: StringName, count: int) -> int:
	if item_id not in item_quantities or item_quantities[item_id] <= 0: return 0
	
	var remaining := count
	
	for i in items.keys():
		if remaining <= 0: break
		if items[i].item_id != item_id: continue
		
		remaining -= items[i].take(remaining)
		if items[i].empty: items.erase(i)
	
	var removed := count - remaining
	
	if removed > 0: item_quantities[item_id] -= removed
	return removed

func remove_item_stack(stack: ItemStack) -> int:
	return remove_item(stack.item_id, stack.count)

func remove_slot(position: int) -> ItemStack:
	var stack: ItemStack = items.get(position)
	items.erase(position)
	return stack

func transfer_item(item_id: StringName, count: int, destination: ItemInventory) -> void:
	var taken := remove_item(item_id, count)
	var given := destination.add_item(item_id, taken)
	
	var refund := taken - given
	if refund > 0:
		var refunded := add_item(item_id, refund)
		assert(refunded == refund, "Unexpected high item count in transfer_item")

func transfer_item_stack(stack: ItemStack, destination: ItemInventory) -> void:
	return transfer_item(stack.item_id, stack.count, destination)

func transfer_item_stacks(stacks: Array[ItemStack], destination: ItemInventory) -> void:
	for i in stacks: transfer_item_stack(i, destination)
