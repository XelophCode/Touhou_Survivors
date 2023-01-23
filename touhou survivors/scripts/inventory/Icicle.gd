extends item_base_class

@export var fragments : PackedScene
var fragment_count:int
var fragments_with_orb:int = 12
var fragments_without_orb:int = 3

func _ready():
	damage = 2
	global_position = Globals.player_position
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	$AnimationPlayer.play("throw")

func _on_area_2d_body_entered(body):
	do_damage(body)
	if occult_orb:
		fragment_count = fragments_with_orb
	else:
		fragment_count = fragments_without_orb
	for i in fragment_count:
		var frag_inst = fragments.instantiate()
		frag_inst.global_position = $main_body.global_position
		get_parent().call_deferred("add_child",frag_inst)
	queue_free()
