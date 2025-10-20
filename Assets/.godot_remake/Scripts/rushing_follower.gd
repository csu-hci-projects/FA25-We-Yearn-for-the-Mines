extends Node2D

@onready var target : CharacterBody2D = get_parent()
const X_MULT : float = 0.3
const Y_MULT : float = 0.2
const MAX_DIST_X : float = 10
const MAX_DIST_Y : float = 10


func _sign(num : float):
	if num < 0:
		return -1
	if num > 0:
		return 1
	else:
		return 0
	
func _physics_process(delta: float) -> void:

	if not is_instance_valid(target):
		return
	
	var target_vel : Vector2 = target.get_real_velocity()
	var move_vect : Vector2 = Vector2(target_vel.x * X_MULT, target_vel.y * Y_MULT)	* delta
	var next_x : float = position.x + move_vect.x
	var next_y : float = position.y + move_vect.y
	if (abs(next_x)) > MAX_DIST_X:
		next_x = MAX_DIST_X * _sign(next_x)
	if (abs(next_y)) > MAX_DIST_Y:
		next_y = MAX_DIST_Y * _sign(next_y)
	
	position = Vector2(next_x, next_y)
	#global_position += move_vect
	#global_position.y = target.global_position.y
