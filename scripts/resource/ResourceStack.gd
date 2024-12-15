class_name ResourceStack extends Resource

signal resource_changed
signal quantity_changed

@export var resource_id: StringName:
	set(val):
		if resource_id == val: return
		resource_id = val
		
		resource_data = ResourceData.get_loaded(resource_id)
		resource_changed.emit()
		quantity = quantity

@export var max_quantity_override := -1
@export var allow_overflow := false
@export var allow_negative := false
@export var quantity: int:
	set(val):
		var old := quantity
		
		quantity = val
		if not allow_overflow and max_quantity >= 0: quantity = mini(max_quantity, quantity)
		if not allow_negative: quantity = maxi(0, quantity)
		
		if quantity != 0: quantity_changed.emit()

var resource_data: ResourceData

var max_quantity: int:
	get:
		if max_quantity_override >= 0: return max_quantity_override
		return resource_data.max_quantity if resource_data else 0

func _init(id := &"", qty := 0) -> void:
	resource_id = id
	quantity = qty

func add(amount: int) -> int:
	var before = quantity
	quantity += amount
	return quantity - before

func remove(amount: int) -> int:
	return -add(-amount)

func merge_into(stack: ResourceStack) -> void:
	if stack.resource_id != resource_id: return
	quantity -= stack.add(quantity)

func merge_from(stack: ResourceStack) -> void:
	stack.merge_into(self)
