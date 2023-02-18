extends Control

func _process(delta):
	if Input.is_action_just_pressed("escape") and get_parent().escape_can_unpause:
		get_parent().is_paused = false
