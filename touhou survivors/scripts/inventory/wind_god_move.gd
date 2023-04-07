extends item_base_class

@export var leaf:PackedScene

func _ready():
	global_position = Globals.player_position
	$main_body.position.y += randf_range(-20,20)
	$main_body/main_body_2.rotation_degrees = randf_range(-15,15)
	$main_body/main_body_2/main_body_3/leaf_points.position.x += randf_range(-40,40)
	damage = randi_range(20,25)

func _on_area_2d_body_entered(body):
	do_damage(body)

func spawn_leafs():
	for i in $main_body/main_body_2/main_body_3/leaf_points.get_child_count():
		var leaf_inst = leaf.instantiate()
		leaf_inst.global_position = $main_body/main_body_2/main_body_3/leaf_points.get_child(i).global_position
		get_parent().call_deferred("add_child",leaf_inst)
