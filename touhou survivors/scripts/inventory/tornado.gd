extends item_base_class

var rot:float
var move_speed:float = 50.0
var frequency:float = 5.0
var amplitude:float = 5.0
var time:float
var y_out:float


func _ready():
	global_position = Globals.player_position
	damage = randi_range(6,9)
	rot = randf_range(0,359)
	$main_body.rotation_degrees = rot
	$main_body/main_body_2.rotation_degrees = -rot
	

func _process(delta):
	time += delta
	var ymove = cos(time*frequency)*amplitude
	y_out += ymove * delta
	$main_body/main_body_2.translate(Vector2(move_speed*delta,y_out))

func _on_animated_sprite_2d_animation_finished():
	if $main_body/main_body_2/AnimatedSprite2D.animation == "default":
		$main_body/main_body_2/AnimatedSprite2D.play("loop")

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_timer_timeout():
	$AnimationPlayer.play("fade_out")
