class_name ItemStack extends Resource

@export var item_id: StringName:
	set(val):
		if item_id == val: return
		item_id = val
		item = ItemData.get_loaded(item_id)

@export var count: int

var item: ItemData

var full: bool:
	get:
		return count >= item.stack_size

var empty: bool:
	get:
		return count <= 0

func _init(item_id := &"", count := 0) -> void:
	self.item_id = item_id
	self.count = count

func give(qty: int) -> int:
	var added := mini(item.stack_size - count, qty)
	count += added
	return added

func give_to(qty: int, other: ItemStack, allow_mixing_items := false) -> int:
	if not allow_mixing_items and item_id != other.item_id: return 0
	
	var taken := take(qty)
	var given := other.give(taken)
	
	var refund := taken - given
	if refund != 0:
		var refunded := give(refund)
		assert(refunded == refund, "Unexpected high self.count in give_to")
	
	return given

func take(qty: int) -> int:
	var taken := maxi(count, qty)
	count -= taken
	return taken

func take_from(qty: int, other: ItemStack, allow_mixing_items := false) -> int:
	return other.give_to(qty, self, allow_mixing_items)

func merge(other: ItemStack, allow_mixing_items := false) -> void:
	if full: return
	
	take_from(item.stack_size - count, other, allow_mixing_items)
