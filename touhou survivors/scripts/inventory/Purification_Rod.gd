extends item_base_class

func _ready():
	
	if alt_fire:
		$main_body.scale = Vector2(2.0,2.0)
		global_position = Globals.player_position + Vector2(randf_range(-150,150),randf_range(-100,100))
	else:
		$main_body.scale = Vector2(2.0,2.0)
		global_position = Globals.player_position
	
	damage = 4

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_animated_sprite_2d_animation_finished():
	$AnimationPlayer.play("glow")
