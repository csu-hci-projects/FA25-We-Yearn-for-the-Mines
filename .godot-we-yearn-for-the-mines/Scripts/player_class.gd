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
const CROUCH_SPEED = 100
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0
var is_crouching : bool = false
var weapon_equipped : bool = false

signal landed_for_first_time
var bool_landed_for_first_time : bool = false

@export var health = 5.0
var current_damage_mult = 0.0
var taking_damage : bool = false
var is_dead : bool = false
var hearts_list : Array[TextureRect]

@onready var rushing_follower : Node2D = $FollowCenter/RushingFollower

@onready var animated_sprite = $AnimatedSprite2D

@onready var standing_collision_shape = $StandingCollisionShape
@onready var crouching_collision_shape = $CrouchingCollisionShape

@onready var raycast_left = $RayCastLeft
@onready var raycast_right = $RayCastRight

@onready var hurt_timer = Timer.new()

@onready var bullet = preload("res://Scenes/PrefabScenes/Bullet.tscn")

func _ready() -> void:
	rushing_follower.setup(self)
	hurt_timer.wait_time = 0.5
	hurt_timer.one_shot = false
	add_child(hurt_timer)
	hurt_timer.timeout.connect(_on_hurt_timer_timeout)
	var hearts_parent = $HealthBar/HBoxContainer
	for child in hearts_parent.get_children():
		hearts_list.append(child)

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
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		var speed = CROUCH_SPEED if is_crouching else SPEED
		velocity.x = speed * direction
	else:
		velocity.x = 0
		
func toggle_flip_sprite(direction):
	if direction == 1:
		animated_sprite.flip_h = false
	if direction == -1: 
		animated_sprite.flip_h = true
		
func handle_movement_animation():
	if is_dead:
		animated_sprite.play("death")
	elif is_on_floor():
		if is_crouching:
			animated_sprite.play("crouch")
		elif !velocity:
			if weapon_equipped:
				animated_sprite.play("shoot")
			else:
				animated_sprite.play("idle")
		else:
			if weapon_equipped:
				animated_sprite.play("run-shoot")
			else:
				animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	toggle_flip_sprite(direction)
		
func check_weapon_equipped():
	if Input.is_action_just_pressed("equip_weapon"):
		weapon_equipped = !weapon_equipped
		
func check_crouching():
	if Input.is_action_pressed("crouch") or raycast_left.is_colliding():
		is_crouching = true
		crouching_collision_shape.disabled = false
		standing_collision_shape.disabled = true
	else:
		is_crouching = false
		crouching_collision_shape.disabled = true
		standing_collision_shape.disabled = false
		
func shoot():
	if weapon_equipped and Input.is_action_just_pressed('shoot'):
		var b = bullet.instantiate()
		b.global_position = $LeftMarker2D.global_position if animated_sprite.flip_h else $RightMarker2D.global_position
		b.direction = -1 if animated_sprite.flip_h else 1
		get_parent().add_child(b)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"):
		taking_damage = true
		current_damage_mult = area.get_parent().DAMAGE_MULT
		hurt_timer.start()
		
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"):
		taking_damage = false
		hurt_timer.stop()
		
func _on_hurt_timer_timeout() -> void:
	if taking_damage:
		_take_damage()	

func _take_damage():
	modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.3).timeout
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	if health > 0:
		health -= current_damage_mult
		_update_heart_display()
	if health <= 0:
		is_dead = true
		print("Player died! rip")
		await get_tree().create_timer(0.3).timeout
		queue_free()
		
func _update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health
	if health <= 1.0:
		hearts_list[0].get_child(0).play("dying")
	elif health > 1.0:
		hearts_list[0].get_child(0).play("idle")
		
func _physics_process(delta: float) -> void:
	_process_vertical_movement(delta)
	_process_horizontal_movement(delta)
	move_and_slide()
	handle_movement_animation()
	check_weapon_equipped()
	check_crouching()
	shoot()
