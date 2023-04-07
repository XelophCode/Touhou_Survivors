extends item_base_class

func _ready():
	damage = randi_range(16,19)
	global_position = Globals.player_position
	$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)

func _process(delta):
	global_position = Globals.player_position

func _on_area_2d_body_entered(body):
	do_damage(body)
