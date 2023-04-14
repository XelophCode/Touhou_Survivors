extends Node2D

@export var revert_label : Label
@export var revert_timer : Timer

func _process(delta):
	if !revert_timer.is_stopped():
		revert_label.text = "changes will revert in " + str(ceili(revert_timer.time_left)) + " seconds"
