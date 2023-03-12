extends item_base_class

@export var fragments : PackedScene
var fragment_count:float = 12.0
var count:float
var direction:bool = false

func _ready():
	
	damage = randi_range(5,6)
	global_position = Globals.player_position
	if alt_fire:
		rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
		$AnimationPlayer.play("throw")
	else:
		$main_body.rotation_degrees = randf_range(0,359.0)

func _process(delta):
	if !alt_fire:
		$main_body.rotation_degrees += delta * 120

func _on_area_2d_body_entered(body):
	do_damage(body)
	if alt_fire:
		for i in fragment_count:
			var frag_inst = fragments.instantiate()
			frag_inst.global_position = $main_body.global_position
			frag_inst.alt = alt_fire
			get_parent().call_deferred("add_child",frag_inst)
		queue_free()


func _on_timer_timeout():
	if !alt_fire:
		if count <= fragment_count:
			count += 1.0
			direction = !direction
			var frag_inst = fragments.instantiate()
			frag_inst.global_position = $main_body.global_position
			frag_inst.alt = alt_fire
			frag_inst.direction = direction
			frag_inst.rotation_degrees = $main_body.rotation_degrees
			get_parent().call_deferred("add_child",frag_inst)
		else:
			queue_free()
