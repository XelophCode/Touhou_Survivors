extends item_base_class

var total_slams:float = 3.0

func _ready():
	
	global_position = Globals.player_position
	damage = randi_range(12,17)

	if alt_fire:
		scale_mod(2.0)
		$slam_anim.play("slam")
		$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)
		$main_body/slam.visible = true
	else:
		Signals.emit_signal("mochi_mallet_swing_sfx")
		$main_body/AnimatedSprite2D.visible = true
		$main_body/Area2D.monitorable = true
		$main_body/Area2D.monitoring = true
		scale_mod(4.0)
		$main_body/AnimatedSprite2D.play("default")
		$AnimationPlayer.play("hitbox_move")
		rotation = deg_to_rad(randi_range(0,359))

func _process(delta):
	global_position = Globals.player_position
	if alt_fire:
		$main_body.rotation = lerp_angle($main_body.rotation,deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing)),delta*2)

func scale_mod(amt):
	scale.x = amt
	scale.y = amt

func _on_area_2d_body_entered(body):
	do_damage(body)

func slam_hitbox_on():
	Signals.emit_signal("mochi_mallet_bash_sfx")
	$main_body/slamhitbox.monitorable = true
	$main_body/slamhitbox.monitoring = true

func slam_hitbox_off():
	$main_body/slamhitbox.monitorable = false
	$main_body/slamhitbox.monitoring = false

func check_for_slam_repeat():
	total_slams -= 1.0
	if total_slams > 0:
		$slam_anim.play("slam")
	else:
		queue_free()


func _on_slamhitbox_body_entered(body):
	do_damage(body)


func _on_timer_timeout():
	queue_free()
