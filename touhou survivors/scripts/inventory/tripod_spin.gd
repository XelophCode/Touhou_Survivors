extends item_base_class

func _ready():
	Signals.emit_signal("tripod_swing_sfx")
	global_position = Globals.player_position
	damage = randi_range(16,19)
	$main_body.rotation_degrees = randf_range(0,359)

func _process(delta):
	$main_body/main_body_2.position.x += delta * 120

func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	do_damage(body)
