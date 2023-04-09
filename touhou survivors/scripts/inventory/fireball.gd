extends item_base_class

@export var small_fireball:PackedScene
var spawn_count:float = 12.0
var small_fire_rot:float

func _ready():
	Signals.emit_signal("fireball_sfx")
	global_position = Globals.player_position
	damage = randi_range(7,9)
	$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)

func _process(delta):
	$main_body/main_body_2.position.x += delta * 60

func _on_area_2d_body_entered(body):
	do_damage(body)
	Signals.emit_signal("fireball_split_sfx")
	for i in spawn_count:
		var small_fire_inst = small_fireball.instantiate()
		small_fire_inst.global_position = $main_body/main_body_2.global_position
		small_fire_inst.rot = $main_body.rotation_degrees + small_fire_rot
		get_parent().call_deferred("add_child",small_fire_inst)
		small_fire_rot -= 30.0
	queue_free()


func _on_timer_timeout():
	queue_free()
