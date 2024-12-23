class_name Recipe extends Resource

static var loaded: Dictionary[StringName, Recipe]
static var product_map: Dictionary[StringName, Array]
static var ingredient_map: Dictionary[StringName, Array]

@export var id: StringName:
	set(val):
		if id == val: return
		if id in loaded: loaded.erase(id)
		id = val
		loaded[id] = self

@export var ingredients: Array[ResourceStack]:
	set(val):
		if ingredients == val: return
		
		for i in ingredients:
			if i.resource_id in ingredient_map and self in ingredient_map[i.resource_id]:
				ingredient_map[i.resource_id].erase(self)
		
		ingredients = val
		
		for i in ingredients:
			if i.resource_id not in ingredient_map: ingredient_map[i.resource_id] = []
			ingredient_map[i.resource_id].push_back(self)

@export var products: Array[ResourceStack]:
	set(val):
		if products == val: return
		
		for i in products:
			if i.resource_id in product_map and self in product_map[i.resource_id]:
				product_map[i.resource_id].erase(self)
		
		products = val
		
		for i in products:
			if i.resource_id not in product_map: product_map[i.resource_id] = []
			product_map[i.resource_id].push_back(self)

@export var texture_override: Texture2D

var texture: Texture2D:
	get:
		return texture_override if texture_override else (products[0].texture if products.size() > 0 else null)

static func get_loaded(id: StringName) -> Recipe:
	return loaded.get(id)

static func get_recipe(item_id: StringName) -> Array[Recipe]:
	return product_map.get(item_id)

static func get_dependents(item_id: StringName) -> Array[Recipe]:
	return ingredient_map.get(item_id)
