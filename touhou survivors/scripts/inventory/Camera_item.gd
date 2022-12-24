extends item_base_class

var enemies_to_damage:Array = []

func _ready():
	damage = 1
	$AnimationPlayer.play("fade_in")
	$AnimationPlayer2.play("shrink")
	global_position = Globals.player_position
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	match stack_count:
		1: scale.x = 0.5;scale.y = 0.5
		2: scale.x = 0.7;scale.y = 0.7
		3: scale.x = 1.0;scale.y = 1.0

func _physics_process(delta):
	global_position = Globals.player_position
	rotation = lerp_angle(rotation, deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing)), delta * 4)
	

func delete():
	for enemy in enemies_to_damage:
		do_damage(enemy)
	queue_free()



func _on_area_2d_body_entered(body):
	enemies_to_damage.append(body)

func _on_area_2d_body_exited(body):
	enemies_to_damage.erase(body)
