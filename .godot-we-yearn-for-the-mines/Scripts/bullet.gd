extends Sprite2D

func _physics_process(delta):
	position.x += 10


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
