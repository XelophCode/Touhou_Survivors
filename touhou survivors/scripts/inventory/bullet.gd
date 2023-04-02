extends item_base_class

var rot:float
var alt:bool

func _ready():
	damage = randi_range(7,10)
	global_position = Globals.player_position
	$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing) + rot

func _process(delta):
	$main_body/main_body_2.position.x += delta * 150

func _on_area_2d_body_entered(body):
	do_damage(body)
	queue_free()

func _on_timer_timeout():
	queue_free()
