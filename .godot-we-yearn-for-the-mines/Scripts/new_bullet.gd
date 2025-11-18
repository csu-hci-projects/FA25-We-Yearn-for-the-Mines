extends CharacterBody2D

@onready var vis_on_scrn : VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D

const SPEED : int = 500
var _dir : Vector2 = Vector2(1,0)
var direction: Vector2:
	get:
		return _dir.normalized()
	set(value):
		_dir = value
		
func _ready() -> void:
	vis_on_scrn.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)

func _physics_process(delta: float) -> void:
	move_and_collide(direction * SPEED * delta)
	print(position)
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	print("Bullet gone")
