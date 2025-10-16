extends CharacterBody2D

# The syntax looks like python, but unlike python, these scripts
#  can't be run on their own. The code contained only means anything
#  and can only be run in the context of the engine. For example,
#  this file is tied to my PlayerClass node that I created in the engine
#  but nowhere in this code does it say that this script is tied to that
#  node. I can only configure that connection in the engine


const SPEED = 90.0
const SPRINT_SPEED = 140.0
const JUMP_VELOCITY = -250.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("reset"):
		pass
	
	# Gravity and Jumping
	if not is_on_floor():
		# Apply gravity every frame
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 650)
		
		# Variable height jump: stop jump if jump button released
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = 0
	elif Input.is_action_just_pressed("jump"):
		velocity.y += JUMP_VELOCITY
		
	# While on floor, velocity 0
	else:
		velocity.y = 0
	
	
	
	# Moving left and right
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		var speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else SPEED
		velocity.x = speed * direction
		#velocity.x = 50 * direction
	else:
		velocity.x = 0
	
	# Move the character based on our adjustments to its 'velocity' member
	move_and_slide()
