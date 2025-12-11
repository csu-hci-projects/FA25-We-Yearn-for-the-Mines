extends Node2D
class_name CustomPCamAreaManager

#@export var trigg_cam_pairs : Array[CameraTriggerLink]
@export var trigg_cam_pairs : Dictionary[DirectionalTriggerArea2D, CameraPair]

signal camera_area_triggered(pcam : PhantomCamera2D)

func _emit_cam_triggered(dirArea : DirectionalTriggerArea2D, going_pos : bool) -> void:
	var camPair : CameraPair = trigg_cam_pairs[dirArea]
	var next_cam : PhantomCamera2D = get_node(camPair.positiveCam) if \
									 going_pos else get_node(camPair.negativeCam)
	camera_area_triggered.emit(next_cam)
	

func _ready() -> void:
	for child in get_children():
		if child is DirectionalTriggerArea2D:
			child.body_entered_going_dir.connect(_emit_cam_triggered)
		else:
			print_debug("Child node ", child.name, " was ignored by parent node ", self.name)
		
