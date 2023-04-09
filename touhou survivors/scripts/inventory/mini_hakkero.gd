extends item_base_class

func _ready():
	Signals.emit_signal("mini_hakkero_sfx")
	if alt_fire:
		$main_body.scale = Vector2(2.0,1.0)
	else:
		$main_body.scale = Vector2(1.0,2.0)
	
	damage = 3
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	$main_body/AnimatedSprite2D.play("default")
	$main_body/AnimatedSprite2D.frame = 0
	$AnimationPlayer.play("fire")

func _process(delta):
	rotation = lerp_angle(rotation,deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing)),1 * delta)
	global_position = Globals.player_position

func _on_animated_sprite_2d_animation_finished():
	queue_free()

func _on_area_2d_body_entered(body):
	do_damage(body)
