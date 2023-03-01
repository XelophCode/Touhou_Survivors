extends item_base_class

var move : Vector2
var move_speed : float = 20
var velocity : Vector2
var scale_rate : float = 1.01
var frequency : float = 5.0
var amplitude : float = 50.0
var time : float


func _ready():
	damage = 3
	
	global_position = Globals.player_position
	move = Vector2(move_speed,0).rotated(deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing)))

func _process(delta):
	time += delta
	if alt_fire:
		var ymove = cos(time*frequency)*amplitude
		$main_body.position.y += ymove * delta
	
	scale.x *= scale_rate
	scale.y *= scale_rate
	velocity = move * delta
	$main_body.translate(velocity)

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_timer_timeout():
	queue_free()
