extends Area2D
class_name DirectionalTriggerArea2D

@export var x_axis : bool
@export var triggering_obj : Node2D

var axis_pos : float :
	get : return global_position.x if x_axis else global_position.y

signal body_entered_going_dir(s : DirectionalTriggerArea2D, going_pos : bool)

enum States {NONE, N_ENT, P_ENT}
var curr_state : States
	
func _on_body_entered(body : Node2D):
	if body == triggering_obj:
		print_debug("Player Entered ", self.name, "\n Curr State: ", curr_state)
		var body_axis_pos : float = body.global_position.x if x_axis else body.global_position.y
		var rel_pos = -1 if body_axis_pos < axis_pos else 1
	
		if curr_state == States.NONE:
			curr_state = States.N_ENT if rel_pos == -1 else States.P_ENT
		else:
			print_debug("Directional Trigger entered more than once without anything exiting")
		
func _on_body_exited(body : Node2D):
	if body == triggering_obj:
		print_debug("Player Exited ", self.name, "\n Curr State: ", curr_state)
		var body_axis_pos : float = body.global_position.x if x_axis else body.global_position.y
		var rel_pos = -1 if body_axis_pos < axis_pos else 1
		
		if curr_state == States.NONE:
			print_debug("Directional Trigger was exited without anything having entered...?")
		else:
			match curr_state:
				States.N_ENT:
					if rel_pos == 1:
						print_debug("Going Positive!!")
						body_entered_going_dir.emit(self, true)
					curr_state = States.NONE
				States.P_ENT:
					if rel_pos == -1:
						print_debug("Going Negative!!")
						body_entered_going_dir.emit(self, false)
					curr_state = States.NONE
	

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	curr_state = States.NONE
	
