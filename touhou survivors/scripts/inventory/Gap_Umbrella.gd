extends item_base_class


func _ready():
	Signals.connect("gap_camera_tween",close_gap1)
	Signals.connect("gap_close",close_gap2)
	global_position = Globals.player_position
	rotation = deg_to_rad(randf_range(0,359))
	$main_body/Gap1.play("default")
	$main_body/Gap2.play("default")
	$main_body/Gap1/Particles.emitting = true
	$main_body/Gap2/Particles.emitting = true
	$main_body/Gap1.rotation = -rotation
	$main_body/Gap2.rotation = -rotation
	$main_body/Area2D.rotation = -rotation
	

func _on_area_2d_body_entered(_body):
	$Timer.stop()
	var teleport_in_pos = $main_body/Gap1.global_position
	teleport_in_pos.y -= 5.5
	var teleport_out_pos = $main_body/Gap2.global_position
	teleport_out_pos.y -= 5.5
	Signals.emit_signal("gap_teleport",teleport_in_pos,teleport_out_pos)
	

func close_gap1(_unused):
	$main_body/Area2D.monitoring = false
	$AnimationPlayer.play("close_gap1")

func close_gap2():
	$AnimationPlayer.play("close_gap2")

func _on_gap_1_animation_finished():
	$main_body/Gap1.stop()
	$main_body/Gap2.stop()
	$main_body/Gap1.frame = 4
	$main_body/Gap2.frame = 4

func _on_timer_timeout():
	$main_body/Area2D.monitoring = false
	$AnimationPlayer.play("close_both_gaps")
