extends item_base_class

var homing:Array
var homing_target
var rot:float

func _ready():
	damage = randi_range(12,16)
	global_position = Globals.player_position
	$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing) + rot

func _process(delta):
	if homing_target != null:
		var aim:Vector2 = $main_body.global_position.direction_to(homing_target.global_position)
		$main_body.rotation = lerp_angle($main_body.rotation,atan2(aim.y,aim.x),0.1)
		var aim_2:Vector2 = $main_body/main_body_2.global_position.direction_to(homing_target.global_position)
		$main_body/main_body_2.rotation = lerp_angle($main_body/main_body_2.rotation,atan2(aim_2.y,aim_2.x),0.1)
	$main_body/main_body_2.position.x += delta * 100

func _on_hit_body_entered(body):
	do_damage(body)
	queue_free()

func _on_homing_body_entered(body):
	homing.append(body)
	homing_target = homing[0]

func _on_homing_body_exited(body):
	homing.erase(body)
	if homing != []:
		homing_target = homing[0]

func _on_timer_timeout():
	queue_free()
