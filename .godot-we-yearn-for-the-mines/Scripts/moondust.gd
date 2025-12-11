extends AnimatedSprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.moondust += 1
		GameManager.play_moondust_pickup_sound()
		
		queue_free() # Replace with function body.
