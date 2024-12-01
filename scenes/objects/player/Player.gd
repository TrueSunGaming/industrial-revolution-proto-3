class_name Player extends CharacterBody2D

@export var base_movement_speed: float
@export var min_zoom: float
@export var max_zoom: float
@export var zoom_factor: float
@export var zoom_time: float

@onready var _goal_zoom: float = $Camera2D.zoom.x

var inventory: ItemInventory

func _ready() -> void:
	refs.player = self

func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * base_movement_speed
	
	move_and_slide()

func _process(delta: float) -> void:
	rotation = global_position.angle_to_point(get_global_mouse_position())
	
	$Camera2D.zoom = $Camera2D.zoom.lerp(Vector2(_goal_zoom, _goal_zoom), delta / zoom_time)

func _input(event: InputEvent) -> void:
	_goal_zoom *= zoom_factor ** (int(Input.is_action_pressed("zoom_in")) - int(Input.is_action_pressed("zoom_out")))
	_goal_zoom = clampf(_goal_zoom, min_zoom, max_zoom)

func save() -> void:
	if not refs.save: return
	
	refs.save.player_inventory = inventory.items
