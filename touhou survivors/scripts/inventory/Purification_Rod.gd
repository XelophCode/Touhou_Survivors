extends item_base_class

func _ready():
	global_position = Globals.player_position
	damage = 2
	$main_body/AnimatedSprite2D.play("default")
	rotation = deg_to_rad(randi_range(0,359))
	match stack_count:
		1: scale_mod(1.4)
		2: scale_mod(1.6)
		3: scale_mod(2.4)
		4: scale_mod(3.2)

func scale_mod(amt):
	scale.x = amt
	scale.y = amt

func _on_animated_sprite_2d_animation_finished():
	$main_body/AnimatedSprite2D.playing = false
	$main_body/AnimatedSprite2D.frame = 13
	$AnimationPlayer.play("spin")
	$AnimationPlayer2.play("move")

func _on_area_2d_body_entered(body):
	do_damage(body)
