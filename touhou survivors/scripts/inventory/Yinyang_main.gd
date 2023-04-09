extends item_base_class

var alt:bool = false
var distance:float


func _ready():
	Signals.emit_signal("yinyang_sfx")
	damage = randi_range(8,12)
	global_position = Globals.player_position

func _process(delta):
	distance += delta * 60
	
	if alt:
		global_position = Globals.player_position
		distance = clamp(distance,0,60.0)
	$main_body.rotation_degrees += delta*200
	$main_body/main_body_2.position.x = distance

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_timer_timeout():
	$AnimationPlayer2.play("fade_out")
