extends Area2D

var blocked:bool = false

func _ready():
	Signals.connect("show_blocked_spaces",catch_show_blocked_spaces)
	Signals.connect("leveling_up",catch_leveling_up)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("right_mouse_button"):
			if blocked:
				if Globals.crystal_count > 0:
					Signals.emit_signal("remove_blocked_space_sfx")
					$AnimationPlayer.play("blocked_space_dissolve")
					monitorable = true
					monitoring = true
					Signals.emit_signal("show_right_click_tip",false)
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
					Globals.crystal_count -= 1.0
					Signals.emit_signal("decrease_crystal_count")
					blocked = false
				else:
					Signals.emit_signal("not_enough_crystals")

func _on_mouse_entered():
	if $BlockedSpace.visible == true and !Globals.holding_item:
		Signals.emit_signal("show_right_click_tip",true)
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_mouse_exited():
	if $BlockedSpace.visible == true:
		Signals.emit_signal("show_right_click_tip",false)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func catch_show_blocked_spaces():
	if blocked:
		$BlockedSpace.visible = true
		$AnimationPlayer.play("show_blocked")

func catch_leveling_up(value):
	if !value:
		$BlockedSpace.visible = false

func blocked_space_invisible():
	$BlockedSpace.visible = false
