extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

var num_hits: int = 0
var is_dead: bool = false

func handle_movement_animation():
	if is_dead: 
		animated_sprite.play("death")
	else: 
		animated_sprite.play("idle")
	
func _physics_process(delta: float) -> void:
	handle_movement_animation()


func _on_area_2d_area_entered(area: Area2D) -> void:
	var name = area.get_parent().name
	if name == "Bullet":
		area.get_parent().queue_free()
		modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.3).timeout
		modulate = Color(1.0, 1.0, 1.0, 1.0)
		num_hits += 1
		if num_hits >= 5:
			is_dead = true
			await get_tree().create_timer(0.3).timeout
			queue_free()
			
	
