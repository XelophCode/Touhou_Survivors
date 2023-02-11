extends item_base_class

func _ready():
	if occult_orb:
		$main_body.scale = Vector2(2.0,3.0)
	else:
		pass
	
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
