extends Area2D

signal camera_area_updated(area : Camera2DConfinerArea)

var active_camera_area : Camera2DConfinerArea = null
var potential_camera_areas : Array[Camera2DConfinerArea] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	camera_area_updated.connect(_update_camera_area)
	
func _update_camera_area(area : Camera2DConfinerArea):
	active_camera_area = area
	#print_debug("PAUSE")

func _on_area_entered(area : Area2D):
	if is_instance_of(area, Camera2DConfinerArea):
		_on_camera_area_entered(area)
	
func _on_area_exited(area : Area2D):
	if is_instance_of(area, Camera2DConfinerArea):
		_on_camera_area_exited(area)

func _on_camera_area_entered(area : Camera2DConfinerArea):
	if active_camera_area == null:
		camera_area_updated.emit(area)
	else:
		potential_camera_areas.append(area)
	#print_debug("CurrectActive: ", active_camera_area, "\nPotential: ", potential_camera_areas)

func _on_camera_area_exited(area : Camera2DConfinerArea):
	if area == active_camera_area:
		camera_area_updated.emit(null)
	elif area in potential_camera_areas:
		potential_camera_areas.remove_at(potential_camera_areas.find(area))
		
	if (active_camera_area == null) and (potential_camera_areas.size() == 1):
		var next_area : Camera2DConfinerArea = potential_camera_areas[0]
		potential_camera_areas.clear()
		camera_area_updated.emit(next_area)
		
	#print_debug("CurrectActive: ", active_camera_area, "\nPotential: ", potential_camera_areas)
