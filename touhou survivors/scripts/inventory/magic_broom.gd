extends item_base_class

var speed_ramp:float = 1.0
@export var star:PackedScene
var star_count:float = 20.0
var rot_flip:bool = false

func _ready():
	global_position = Globals.player_position
	damage = randi_range(6,8)
	if alt_fire:
		$AnimationPlayer.play("spin")
		$main_body/main_body_2.scale = Vector2(1.5,1.5)
	else:
		$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)

func _process(delta):
	if alt_fire:
		global_position = Globals.player_position
	else:
		speed_ramp += delta * 30
		speed_ramp = clamp(speed_ramp,1.0,150.0)
		$main_body/main_body_2.position.x += delta * speed_ramp

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_timer_timeout():
	queue_free()

func _on_spawn_star_timeout():
	if star_count > 0:
		star_count -= 1.0
		var star_inst = star.instantiate()
		star_inst.global_position = $main_body/main_body_2.global_position
		
		if alt_fire:
			star_inst.rot = $main_body.rotation_degrees
		else:
			rot_flip = !rot_flip
			if rot_flip:
				star_inst.rot = 270.0 + $main_body.rotation_degrees
			else:
				star_inst.rot = 90 + $main_body.rotation_degrees
		get_parent().call_deferred("add_child",star_inst)
	else:
		if alt_fire:
			await get_tree().create_timer(1.0).timeout
			queue_free()
