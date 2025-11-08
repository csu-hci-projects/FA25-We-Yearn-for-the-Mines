extends Sprite2D

var direction = -1
func _physics_process(delta):

	if direction > 0:
		position.x += 10
	else:
		position.x -= 10
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
