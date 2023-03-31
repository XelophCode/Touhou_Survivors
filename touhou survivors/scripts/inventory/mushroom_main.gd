extends item_base_class

var alt:bool

func _ready():
	damage = randi_range(1,2)
	global_position = Globals.player_position
	$main_body/main_body_2/main_body_3.rotation_degrees = randf_range(0,359)
	if alt:
		await get_tree().create_timer(0.4).timeout
		explode()
	else:
		$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)
		$main_body.rotation_degrees += randf_range(-45,45)
		$main_body/main_body_2/Shadow.rotation_degrees = -$main_body.rotation_degrees
		$AnimationPlayer.play("bounce")

func explode():
	$AnimationPlayer.play("explode")

func _on_area_2d_body_entered(body):
	do_damage(body)
