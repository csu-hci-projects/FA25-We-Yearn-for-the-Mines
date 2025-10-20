extends Camera2D

# @export is the equivalent of [SerializeField] in C# for Unity
@onready var parent : Node2D = get_parent()
@onready var player = parent.player

func _process(delta: float) -> void:
	if is_instance_valid(player):
		global_position = player.rushing_follower.global_position
	else:
		print("Target is null")
