extends Control

func _process(_delta):
	if Input.is_action_just_pressed("escape") and get_parent().escape_can_unpause:
		if $Options_Menu.visible:
			$pause_anims.play_backwards("scroll")
		else:
			get_parent().is_paused = false
