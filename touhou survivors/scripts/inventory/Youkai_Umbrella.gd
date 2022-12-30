extends item_base_class

var spawn_counter:int = 0
var umbrella = preload("res://prefabs/item_spawnables/utilities/Umbrella_Main.tscn")

func _ready():
	global_position = Globals.player_position
	var rand_rot = deg_to_rad(randi_range(0,359))
	var count = 0
	for i in stack_count:
		var umbrella_inst = umbrella.instantiate()
		umbrella_inst.rotation = rand_rot + (90 * count)
		count += 1
		get_parent().call_deferred("add_child",umbrella_inst)
	queue_free()
