extends item_base_class

func _ready():
	global_position = Globals.player_position
	if alt_fire:
		$main_body/spin.emitting = true
		$anims.play("hitbox_spin")
	else:
		$main_body/sweep.emitting = true
		$anims.play("hitbox_sweep")
		rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)
	damage = 5.0

func _process(delta):
	if alt_fire:
		global_position = Globals.player_position

func _on_area_2d_body_entered(body):
	do_damage(body)
