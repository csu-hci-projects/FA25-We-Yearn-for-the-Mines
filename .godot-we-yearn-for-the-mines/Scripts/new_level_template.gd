extends Node2D

@onready var player : PlayerClass = $PlayerNode
@onready var pcam_manager : CustomPCamManager = $PCamManager
@onready var pcam_area_manager : CustomPCamAreaManager = $PCamAreaManager

func _ready() -> void:
	pcam_area_manager.camera_area_triggered.connect(pcam_manager.update_camera)
