extends item_base_class

var rot:float
var aimed_rot:float
var alt:bool = false

func _ready():
	Signals.emit_signal("knife_throw_sfx")
	damage = randi_range(3,5)
	global_position = Globals.player_position
	if alt:
		rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)
	$main_body.rotation_degrees = rot

func _process(delta):
	$main_body/main_body_2.position.x += delta*120

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_timer_timeout():
	queue_free()
