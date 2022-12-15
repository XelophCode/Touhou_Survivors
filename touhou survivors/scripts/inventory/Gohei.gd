extends item_base_class

var anim_counter:int = 0

func _ready():
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	$main_body/swing/swing_sprite.play("swing")
	$main_body/slash/slash_sprite.play("slash")
	$AnimationPlayer.play("slash_move")
	match stack_count:
		1: damage = 1
		2: damage = 2
		3: damage = 3
		_:pass

func _physics_process(_delta):
	global_position = Globals.player_position

func _on_hitbox_body_entered(body):
	do_damage(body)

func _on_swing_sprite_animation_finished():
	if anim_counter == 0:
		$main_body.scale.y = -1
		$main_body/swing/swing_sprite.play("swing")
		$main_body/slash/slash_sprite.play("slash")
		$AnimationPlayer.play("slash_move")
		anim_counter += 1
	else:
		queue_free()
