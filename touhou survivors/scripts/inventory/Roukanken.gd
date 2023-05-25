extends item_base_class

func _ready():
	global_position = Globals.player_position
	if alt_fire:
		Signals.emit_signal("roukanken_spin_sfx")
		$anims.play("hitbox_spin")
	else:
		Signals.emit_signal("roukanken_flurry_sfx")
		$anims.play("hitbox_sweep")
		rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)
	damage = randi_range(8,10)

func _process(_delta):
	global_position = Globals.player_position

func _on_area_2d_body_entered(body):
	do_damage(body)
