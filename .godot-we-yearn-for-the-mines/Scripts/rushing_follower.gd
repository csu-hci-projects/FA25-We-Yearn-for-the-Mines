# Rushing Follower
extends Node2D

var target : CharacterBody2D

const X_MULT : float = 0.375
const Y_MULT : float = 0.375
const MAX_DIST_X : float = 52
const MAX_DIST_Y_ABOVE : float = 32
const MAX_DIST_Y_BELOW : float = 100

func unpause():
	#print_debug("follower unpaused")
	process_mode = Node.PROCESS_MODE_INHERIT
	
func setup(in_target : CharacterBody2D):
	target = in_target
	target.landed_for_first_time.connect(unpause)

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	
func _physics_process(delta: float) -> void:

	if not is_instance_valid(target):
		return
	
	#var target_vel : Vector2 = target.get_real_velocity()
	#if target_vel.x != 0:
		#position.x = MAX_DIST_X if target_vel.x > 0 else -MAX_DIST_X
	
	var target_vel : Vector2 = target.get_real_velocity()
	var move_vect : Vector2 = Vector2(target_vel.x * X_MULT, target_vel.y * Y_MULT)	* delta
	var dir_match_x : float = target_vel.x * position.x
	var dir_match_y : float = target_vel.y * position.y
	
	# If swapped directions, reset x to 0. Same for y
	var next_x : float = (position.x + move_vect.x) if (dir_match_x >= 0) else 0.0
	
	# If target y velocity is 0, y follower position = 0 immediately (not just when change direction)
	var next_y : float = 0.0
	if target_vel.y != 0:
		next_y = (position.y + move_vect.y) if (dir_match_y >= 0) else 0.0

	
	if (abs(next_x)) > MAX_DIST_X:
		next_x = MAX_DIST_X * sign(next_x)
	var MAX_DIST_Y = MAX_DIST_Y_ABOVE if target_vel.y < 0 else MAX_DIST_Y_BELOW
	if (abs(next_y)) > MAX_DIST_Y:
		next_y = MAX_DIST_Y * sign(next_y)
	
	position = Vector2(next_x, next_y)
	
	#global_position += move_vect
	#global_position.y = target.global_position.y
