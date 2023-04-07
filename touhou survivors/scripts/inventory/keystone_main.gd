extends item_base_class

var alt:bool

func _ready():
	$main_body.global_position = Globals.player_position + Vector2(randf_range(-120,120),randf_range(-80,80))
	if alt:
		damage = randi_range(30,35)
		$main_body.scale = Vector2(2.5,2.5)
	else:
		damage = randi_range(8,10)
	$AnimationPlayer.play("falling")

func collision():
	if alt:
		Signals.emit_signal("keystone_large_sfx")
	else:
		Signals.emit_signal("keystone_small_sfx")
	$main_body/Keystone.play("collision")
	$main_body/Area2D.monitoring = true

func _on_keystone_animation_finished():
	if $main_body/Keystone.animation == "collision":
		$main_body/Keystone.play("finished")
		$main_body/Area2D.monitoring = false
		$Timer.start()

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_timer_timeout():
	$AnimationPlayer.play("fade_out")
