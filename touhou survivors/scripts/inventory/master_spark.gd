extends item_base_class

var loop_count:float = 3.0
@export var star:PackedScene
var is_looping:bool = false

func _ready():
	Signals.emit_signal("master_spark_sfx")
	damage = randi_range(5,8)
	$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)
	global_position = Globals.player_position

func _process(delta):
	global_position = Globals.player_position
	$main_body.rotation = lerp_angle($main_body.rotation,deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing)),delta/8)

func loop_fire():
	is_looping = true
	$main_body/main_body_2/main_body_3/AnimatedSprite2D.play("loop")

func _on_animated_sprite_2d_animation_looped():
	if loop_count > 0:
		loop_count -= 1.0
	else:
		$AnimationPlayer.play("stop_fire")
		is_looping = false

func _on_area_2d_body_entered(body):
	damage = randi_range(5,8)
	do_damage(body)


func _on_timer_timeout():
	if is_looping:
		$main_body/main_body_2/main_body_3/Area2D.monitoring = false
		$main_body/main_body_2/main_body_3/Area2D.monitorable = false
		await get_tree().create_timer(0.1).timeout
		$main_body/main_body_2/main_body_3/Area2D.monitoring = true
		$main_body/main_body_2/main_body_3/Area2D.monitorable = true
