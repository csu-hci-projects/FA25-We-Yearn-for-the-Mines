extends Node2D

class_name LevelTemplate

@onready var player : PlayerClass = $PlayerNode
@onready var confined_camera : ConfinedCamera2D = $ConfinedCamera2D

func _ready() -> void:
	confined_camera.setup_player_to_track(player)
	player.camera_area_updated.connect(confined_camera.update_limits)
