extends Node2D
class_name CustomPCamManager

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
		
func update_camera(cam : PhantomCamera2D) -> void:
	print_debug("Updating_camera to ", cam.name)
	var next_cam : PhantomCamera2D = pcams[cam.name]
	
	next_cam.global_position = curr_cam.global_position	
	curr_cam.set_priority(0)
	curr_cam = next_cam
	curr_cam.set_priority(1)
	for lcam in pcams.values():
		print(lcam, " ", lcam.get_priority())
