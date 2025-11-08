extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

var num_hits: int = 0
var is_dead: bool = false
@export var MAX_HITS = 5
@export var DAMAGE_MULT: float = 1.0
@export var amplitude: float = 30.0 #how far up and down
@export var horizontal: float = 0.0
@export var speed: float = 2.0
@export var can_walk = false

var base_y: float #starting height 
var base_x: float 

func _ready():
	base_y = global_position.y
	base_x = global_position.x
	
func handle_movement_animation():
	if is_dead: 
		animated_sprite.play("death")
	else: 
		if can_walk:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
		
func _physics_process(delta: float) -> void:
	if not is_dead:
		var y_offset = sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude
		global_position.y = base_y + y_offset
		var x_offset = sin(Time.get_ticks_msec() / 1000.0 * speed) * horizontal
		global_position.x = base_x + x_offset
	handle_movement_animation()


func _on_area_2d_area_entered(area: Area2D) -> void:
	var name = area.get_parent().name
	if name == "Bullet":
		area.get_parent().queue_free()
		modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.3).timeout
		modulate = Color(1.0, 1.0, 1.0, 1.0)
		num_hits += 1
		if num_hits >= MAX_HITS:
			is_dead = true
			await get_tree().create_timer(0.3).timeout
			queue_free()
			
	
