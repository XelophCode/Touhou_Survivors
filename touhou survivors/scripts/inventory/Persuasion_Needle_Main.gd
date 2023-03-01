extends item_base_class

var alt:bool

func _ready():
	$main_body.scale = Vector2(2.0,2.0)
	global_position = Globals.player_position
	if alt:
		rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing) + 180
	else:
		rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	damage = 1
	$AnimationPlayer2.play("throw")

func _on_area_2d_body_entered(body):
	do_damage(body)
	queue_free()

func delete():
	queue_free()
