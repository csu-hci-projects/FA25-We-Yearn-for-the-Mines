extends Node2D
class_name CustomPCamManager

# The camera set to the highest priority will be considered the
# "loading" camera, and after a certain amount of time, the camera will
# automatically update to the PhantomCamera2D
@export var initial_cam : PhantomCamera2D
var pcams : Dictionary[String, PhantomCamera2D] = {}
var curr_cam : PhantomCamera2D = null

func _ready() -> void:
	for child in get_children():
		if child is PhantomCamera2D:
			pcams[child.name] = child
			if curr_cam == null:
				curr_cam = child
			elif curr_cam.get_priority() < child.get_priority():
				curr_cam.set_priority(0)
				curr_cam = child
		else:
			print_debug("Child node ", child.name, " was ignored by parent node ", self.name)
	if curr_cam == null:
		print_debug("PCamManager ", self.name, " has no PCams to Manage!")
	else:
		curr_cam.set_priority(1)
	
	get_tree().create_timer(0.3).timeout.connect(_update_camera_to_initial_cam)
	
func _update_camera_to_initial_cam() -> void:
	update_camera(initial_cam)
		
func update_camera(cam : PhantomCamera2D) -> void:
	print_debug("Updating_camera to ", cam.name)
	var next_cam : PhantomCamera2D = pcams[cam.name]
	
	next_cam.global_position = curr_cam.global_position	
	curr_cam.set_priority(0)
	curr_cam = next_cam
	curr_cam.set_priority(1)
	for lcam in pcams.values():
		print(lcam, " ", lcam.get_priority())
