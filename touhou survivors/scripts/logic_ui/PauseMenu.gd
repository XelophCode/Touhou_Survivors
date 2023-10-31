extends Control

@export var resume_button : Button

func _process(_delta):
	if (Input.is_action_just_pressed("escape") or Input.is_action_just_pressed("b_button_press") or Input.is_action_just_pressed("start_button_press")) and get_parent().escape_can_unpause:
		if $Options_Menu.visible:
			pass
#			Signals.emit_signal("close_options_menu")
		else:
			if get_parent().leveling_up:
				get_parent().hand_icon.show()
			get_parent().is_paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func focus_resume():
	resume_button.grab_focus()
