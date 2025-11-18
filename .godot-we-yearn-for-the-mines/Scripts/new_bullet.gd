extends CharacterBody2D

@onready var vis_on_scrn : VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D

const SPEED : int = 600
var _dir : Vector2 = Vector2(1,0)
var direction: Vector2:
	get:
		return _dir.normalized()
	set(value):
		_dir = value
		
func _ready() -> void:
	print_debug("Bullet Here!")
	vis_on_scrn.screen_exited.connect(queue_free)

func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(direction * SPEED * delta)
	if collision:
		handle_bullet_collision(collision)
	
func handle_bullet_collision(collision : KinematicCollision2D) -> void:
	var collider = collision.get_collider()
	if collider is TileMapLayer and collider.is_in_group("destructible"):
		# 1. Precision math to get the tile inside the wall
		var hit_pos = collision.get_position() - collision.get_normal()
		
		# 2. Convert to map coordinates
		var local_pos = collider.to_local(hit_pos)
		var tile_coords = collider.local_to_map(local_pos)
		
		# 3. Destroy the tile
		collider.set_cell(tile_coords, -1)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	print_debug("Bullet gone")
