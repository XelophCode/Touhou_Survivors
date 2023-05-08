extends Control

func _process(_delta):
	if Input.is_action_just_pressed("escape") and get_parent().escape_can_unpause:
		if $Options_Menu.visible:
			pass
#			Signals.emit_signal("close_options_menu")
		else:
			get_parent().is_paused = false
