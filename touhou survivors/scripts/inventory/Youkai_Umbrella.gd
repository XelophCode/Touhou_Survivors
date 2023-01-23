extends item_base_class


@export var umbrella : PackedScene
var spawn_count:int
@export var umbrellas_with_orb:int = 3
@export var umbrellas_without_orb:int = 1

func _ready():
	if occult_orb:
		spawn_count = umbrellas_with_orb
	else:
		spawn_count = umbrellas_without_orb
	
	global_position = Globals.player_position
	var rand_rot = deg_to_rad(randi_range(0,359))
	var count = 0
	for i in spawn_count:
		var umbrella_inst = umbrella.instantiate()
		umbrella_inst.rotation = rand_rot + (90 * count)
		count += 1
		get_parent().call_deferred("add_child",umbrella_inst)
	queue_free()
