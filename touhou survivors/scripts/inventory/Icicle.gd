extends item_base_class

var fragments = preload("res://prefabs/item_spawnables/utilities/Icicle_Fragments.tscn")

func _ready():
	damage = 2
	global_position = Globals.player_position
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	$AnimationPlayer.play("throw")

func _on_area_2d_body_entered(body):
	do_damage(body)
	for i in stack_count:
		var frag_inst = fragments.instantiate()
		frag_inst.global_position = $main_body.global_position
		get_parent().call_deferred("add_child",frag_inst)
	queue_free()
