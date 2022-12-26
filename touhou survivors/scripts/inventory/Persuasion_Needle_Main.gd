extends item_base_class

func _ready():
	global_position = Globals.player_position
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	damage = 1
	$AnimationPlayer2.play("throw")

func _on_area_2d_body_entered(body):
	do_damage(body)
	queue_free()

func delete():
	queue_free()
