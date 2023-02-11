extends item_base_class

func _ready():
	rotation = deg_to_rad(randi_range(0,359))
	global_position = Globals.player_position
	damage = 10
	$main_body/AnimatedSprite2D.play("default")
	$AnimationPlayer.play("hitbox_move")
	if occult_orb:
		scale_mod(6.0)
	else:
		scale_mod(3.0)

func _process(_delta):
	global_position = Globals.player_position

func scale_mod(amt):
	scale.x = amt
	scale.y = amt

func _on_area_2d_body_entered(body):
	do_damage(body)
