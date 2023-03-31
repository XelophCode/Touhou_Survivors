extends item_base_class

var rot_speed:float

func _ready():
	$main_body.rotation_degrees = randf_range(0,359)
	global_position = Globals.player_position
	damage = randi_range(30,37)
	rot_speed = Globals.pos_neg(120)

func _process(delta):
	global_position = Globals.player_position
	$main_body.rotation_degrees += delta * rot_speed

func _on_animated_sprite_2d_frame_changed():
	if $main_body/main_body_2/AnimatedSprite2D.frame == 7:
		$main_body/main_body_2/Area2D.monitorable = true
		$main_body/main_body_2/Area2D.monitoring = true

func _on_animated_sprite_2d_animation_finished():
	$AnimationPlayer.play("fade_out")
	$main_body/main_body_2/Area2D.monitoring = false
	$main_body/main_body_2/Area2D.monitorable = false

func play_anim():
	$main_body/main_body_2/AnimatedSprite2D.play("default")

func _on_area_2d_body_entered(body):
	do_damage(body)
