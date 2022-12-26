extends Node2D

var structure_locations:Array
var rand_pos_neg:Array = [-300,300]
@export var structures : FolderListResource

func _ready():
	var x_spawn:Array = []
	var y_spawn:Array = []
	var count:float = 1
	for i in 19:
		x_spawn.append(count)
		y_spawn.append(count)
		count += 1
	
	count = -1
	for ii in 19:
		x_spawn.append(count)
		y_spawn.append(count)
		count -= 1
	
	x_spawn.shuffle()
	y_spawn.shuffle()
	
	for spawn in 38:
		var xsp = x_spawn.pop_front()
		var ysp = y_spawn.pop_front()
		var spawn_location = Vector2(xsp,ysp) * rand_pos_neg.pick_random()
		structure_locations.append(spawn_location)
		var struct_inst = structures.all_resources.pick_random().instantiate()
		struct_inst.global_position = spawn_location
		$structure_parent.add_child(struct_inst)
	
