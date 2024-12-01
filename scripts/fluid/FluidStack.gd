class_name FluidStack extends Resource

# TODO: abstract FluidStack and ItemStack into an ObjectStack class

@export var fluid_id: StringName:
	set(val):
		if fluid_id == val: return
		fluid_id = val
		fluid = FluidData.get_loaded(fluid_id)

@export var amount: float
@export var capacity := INF

var fluid: FluidData

var full: bool:
	get:
		return amount >= capacity

var empty: bool:
	get:
		return amount <= 0

func _init(fluid_id := &"", amount := 0) -> void:
	self.fluid_id = fluid_id
	self.amount = amount

func give(qty: float) -> float:
	var added := mini(capacity - amount, qty)
	amount += added
	return added

func give_to(qty: float, other: FluidStack, allow_mixing_fluids := false) -> float:
	if not allow_mixing_fluids and fluid_id != other.fluid_id: return 0
	
	var taken := take(qty)
	var given := other.give(taken)
	
	var refund := taken - given
	if refund != 0:
		var refunded := give(refund)
		assert(refunded == refund, "Unexpected high self.amount in give_to")
	
	return given

func take(qty: float) -> float:
	var taken := maxi(amount, qty)
	amount -= taken
	return taken

func take_from(qty: float, other: FluidStack, allow_mixing_fluids := false) -> float:
	return other.give_to(qty, self, allow_mixing_fluids)

func merge(other: FluidStack, allow_mixing_fluids := false) -> void:
	if full: return
	
	take_from(capacity - amount, other, allow_mixing_fluids)
