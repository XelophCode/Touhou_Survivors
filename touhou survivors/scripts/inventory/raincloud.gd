extends item_base_class

var move:float
var rot:float

func _ready():
	global_position = Globals.player_position
	rot = randf_range(0,359)
	damage = randi_range(10,12)
	$main_body.rotation_degrees = rot
	$main_body/main_body_2.rotation_degrees = -rot

func _process(delta):
	$main_body/main_body_2.position.x += delta * 40

func _on_animated_sprite_2d_animation_finished():
	if $main_body/main_body_2/AnimatedSprite2D.animation == "default":
		$main_body/main_body_2/AnimatedSprite2D.play("loop")

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_timer_timeout():
	$AnimationPlayer.play("fade_out")

func _on_toggle_damage_timeout():
	$main_body/main_body_2/Area2D.monitorable = false
	$main_body/main_body_2/Area2D.monitoring = false
	await get_tree().create_timer(0.1).timeout
	$main_body/main_body_2/Area2D.monitorable = true
	$main_body/main_body_2/Area2D.monitoring = true
