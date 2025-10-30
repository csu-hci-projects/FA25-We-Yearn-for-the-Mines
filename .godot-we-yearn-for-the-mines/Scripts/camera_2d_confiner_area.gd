# Camera2D Confiner Area
extends Area2D
class_name Camera2DConfinerArea

static var id_counter : int = 0
var id : int = 0

#@onready var confiner : Camera2DConfiner = get_parent()
@onready var shape : CollisionShape2D = $TriggerArea

@export var left_lim_toggle   : bool = false
@export var right_lim_toggle  : bool = false
@export var top_lim_toggle    : bool = false
@export var bottom_lim_toggle : bool = false

const INF_HI : int = 10000000
const INF_LO : int = (-1) * INF_HI

func _init():
	id_counter += 1
	id = id_counter
	
func get_limit_toggles() -> Array[bool]:
	return [left_lim_toggle, right_lim_toggle, top_lim_toggle, bottom_lim_toggle]	

func get_limits() -> Vector4:
	var rect : RectangleShape2D = shape.get_shape()
	var x_off : float = rect.size.x / 2
	var y_off : float = rect.size.y / 2
	var limits : Array[int] = [
		floor(shape.global_position.x - x_off),
		ceil(shape.global_position.x + x_off),
		floor(shape.global_position.y - y_off),
		ceil(shape.global_position.y + y_off),
	]
	var lim_tog : Array[bool] = [
		left_lim_toggle,
		right_lim_toggle, 
		top_lim_toggle,
		bottom_lim_toggle,
	]
	for i in range(limits.size()):
		if not lim_tog[i]:
			if (i % 2):
				limits[i] = INF_HI
			else:
				limits[i] = INF_LO
	var limits_vect : Vector4 = Vector4(
		limits[0], 
		limits[1], 
		limits[2], 
		limits[3]
	)
	return limits_vect
