# Player Prefab
extends CharacterBody2D
class_name PlayerClass
 
# The syntax looks like python, but unlike python, these scripts
#  can't be run on their own. The code contained only means anything
#  and can only be run in the context of the engine. For example,
#  this file is tied to my PlayerClass node that I created in the engine
#  but nowhere in this code does it say that this script is tied to that
#  node. I can only configure that connection in the engine itself

# Physics Values
const SPEED = 135
const SPRINT_SPEED = 230
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal landed_for_first_time
var bool_landed_for_first_time : bool = false

signal camera_area_updated(area : Camera2DConfinerArea)

@onready var rushing_follower : Node2D = $FollowCenter/RushingFollower
@onready var transition_detector : Area2D = $TransitionDetectorArea

func _ready() -> void:
	rushing_follower.setup(self)
	transition_detector.camera_area_updated.connect(camera_area_updated.emit)

func get_offset_tracking_pos() -> Vector2:
	if is_instance_valid(rushing_follower):
		return rushing_follower.global_position
	else:
		print_debug("Player's Rushing Follower Doesn't Exist??")
		return Vector2(0,0)

func _process_vertical_movement(delta: float) -> void:
		# Gravity and Jumping
	if not is_on_floor():
		# Apply gravity every frame
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 650)
		
		# Variable height jump: stop jump if jump button released
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = 0
	else:
		if not bool_landed_for_first_time:
			bool_landed_for_first_time = true
			landed_for_first_time.emit()
		
		elif Input.is_action_just_pressed("jump"):
			velocity.y += JUMP_VELOCITY
		# While on floor, velocity 0
		else:
			velocity.y = 0
func _process_horizontal_movement(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		var speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else SPEED
		velocity.x = speed * direction
	else:
		velocity.x = 0

func _physics_process(delta: float) -> void:
	_process_vertical_movement(delta)
	_process_horizontal_movement(delta)
	move_and_slide()
	
