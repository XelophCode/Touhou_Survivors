extends item_base_class

func _ready():
	damage = 1
	global_position = Globals.player_position
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	$AnimationPlayer.play("throw")

func delete():
	queue_free()

func _on_area_2d_body_entered(body):
	do_damage(body)
