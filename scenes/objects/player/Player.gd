class_name Player extends CharacterBody2D

@export var base_movement_speed: float

func _ready() -> void:
	refs.player = self

func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * base_movement_speed
	
	move_and_slide()

func _process(delta: float) -> void:
	rotation = global_position.angle_to_point(get_global_mouse_position())
