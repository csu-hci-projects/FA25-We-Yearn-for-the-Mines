extends Camera2D
class_name ConfinedCamera2D

var player_to_track : PlayerClass = null

# This is the limit value that the camera will update to match
var goal_limit_vec : Vector4

# This is the limit value that the camera currently uses. It's stored as a
# Vector4, meaning that limits are now floats and not ints, allowing for
# smoother updating. When the camera's limits are actually set, these values
# are casted to ints using both ceil() and floor(), due to the type requirements
var curr_limit_vec : Vector4 

var start_limit_vec : Vector4

var matches_goal : bool = true

func _ready() -> void:
	curr_limit_vec = Vector4(
		limit_left,
		limit_right,
		limit_top,
		limit_bottom,
	) 

func setup_player_to_track(player : PlayerClass) -> void:
	player_to_track = player

func _widen_limit_walls(limit_vec : Vector4, toggles : Array[bool]) -> Vector4:
	for i in range(4): # Assumes the toggle is an array of length 4
		if not toggles[i]:
			var direction : float = -1.0 if (i % 2 == 0) else 1.0
			limit_vec[i] = curr_limit_vec[i] + (1000 * direction)
	return limit_vec

func update_limits(limit_area : Camera2DConfinerArea) -> void:
	print_debug("updating_goal_limits")
	
	# Plain and simple implementation: Set the limits to the ones received.
	#if limit_area != null:
		#var limits_vect : Vector4 = limit_area.get_limits()
		#limit_left   = int(limits_vect.x)
		#limit_right  = int(limits_vect.y)
		#limit_top    = int(limits_vect.z)
		#limit_bottom = int(limits_vect.w)

	if limit_area != null:
		var limit_vec : Vector4 = limit_area.get_limits()
		var limit_toggles : Array[bool] = limit_area.get_limit_toggles()
		goal_limit_vec = _widen_limit_walls(limit_vec, limit_toggles)
		start_limit_vec = Vector4(curr_limit_vec)
		matches_goal = false
		print_debug("Area Update:\nGivenLimits: ", limit_vec, "\nGoalLimits: ", goal_limit_vec)
	
	

func _physics_process(delta: float) -> void:
	#print_debug(_get_actual_viewport_center())
	if is_instance_valid(player_to_track):
		var new_glob_pos : Vector2 = player_to_track.get_offset_tracking_pos()
		global_position = new_glob_pos
	if not matches_goal:
		if curr_limit_vec == goal_limit_vec:
			matches_goal = true
			return
		else:
			# There are 3 possible rates to updating the vector representing the
			# camera's limits:
			# 1) Traveling a faction of the distance every frame (say, 1/6th).
			#    But only if that distance is larger than the option below,
			# 2) Travelling some set distance every frame. Consider this a 
			#    "minimum speed" of sorts. But when this distance ends of being
			#    larger than the *total* distance, then choose the option below
			# 3) Simply travel the rest of the way in one frame. 
			
			# Option 1 is for larger gaps, option 2 is for medium gaps, and 
			# option 3 is to prevent jittering when approaching the final answer
			# or in other words, for small gaps.
			
			
			var slow_window : float = 100
			for i in range(4): # for all 4 direcetions
				if goal_limit_vec[i] == curr_limit_vec[i]:
					continue
				var side : float = -1.0 if (i % 2) == 0 else 1.0
				var displacement : float  = goal_limit_vec[i] - curr_limit_vec[i]
				var distance : float = abs(displacement)
				var direction : float = displacement / distance
				var slow_speed : float = delta * 400 # max(distance * delta, 100 * delta)
				if distance <= slow_window:
					# Distance is low, so just move slowly
					if distance < slow_speed:
						curr_limit_vec[i] += displacement
					elif direction == side and distance < 64:
						curr_limit_vec[i] += slow_speed * direction
					else:
						curr_limit_vec[i] += displacement / 16
				elif direction == side: # If you're moving away
					# Distance is somewhat wide & you're moving away
					# Check distance from start_limit_vec, if less than slow window, move slowly
					if abs(curr_limit_vec[i] - start_limit_vec[i]) < slow_window:
						curr_limit_vec[i] += slow_speed * direction
					else:
						curr_limit_vec[i] = goal_limit_vec[i]
				else:
					# Distance is somewhat wide & you're moving towards.
					# Travel up to the slow_window instantly
					curr_limit_vec[i] += (displacement - (slow_window * direction))
					
			
			#var direction : Vector4 = curr_limit_vec.direction_to(goal_limit_vec)
			#var full_update : Vector4 = direction * curr_limit_vec.distance_to(goal_limit_vec)
			#var slow_update : Vector4 = direction * delta * 450
			#var fast_update : Vector4 =  full_update / 12
			#
			#var update_vect : Vector4
			#if full_update.length() < slow_update.length():
				#update_vect = full_update
			##elif slow_update.length() < fast_update.length():
				##update_vect = fast_update
			#else:
				#update_vect = slow_update
			##var diff_vect : Vector4 = direction * curr_limit_vec.distance_to(goal_limit_vec)
			#curr_limit_vec = curr_limit_vec + update_vect
			##print_debug(curr_limit_vec)
		limit_left   = ceil(curr_limit_vec.x)
		limit_right  = floor(curr_limit_vec.y)
		limit_top    = ceil(curr_limit_vec.z)
		limit_bottom = floor(curr_limit_vec.w)
		print_debug("Goal ", goal_limit_vec, "\nCurr ", curr_limit_vec, "\nMatches: ", matches_goal)
		
