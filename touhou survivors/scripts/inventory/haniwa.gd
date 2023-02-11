extends item_base_class

var move : Vector2
var move_speed : float = 10
var velocity : Vector2
var scale_rate : float = 1.01

func _ready():
	if occult_orb:
		move_speed = 10
		damage = 4
	else:
		move_speed = 30
		damage = 2
	
	global_position = Globals.player_position
	move = Vector2(move_speed,0).rotated(deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing)))

func _process(delta):
	scale.x *= scale_rate
	scale.y *= scale_rate
	velocity = move * delta
	$main_body.translate(velocity)

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_timer_timeout():
	queue_free()
