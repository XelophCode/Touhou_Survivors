extends item_base_class

@export var yinyang:PackedScene
var spawn_count:float = 3.0
var rot_amt:float

func _ready():
	if alt_fire:
		spawn_count = 1.0
	for i in spawn_count:
		var yinyang_inst = yinyang.instantiate()
		yinyang_inst.rotation_degrees = rot_amt
		yinyang_inst.alt = alt_fire
		get_parent().call_deferred("add_child",yinyang_inst)
		rot_amt += 120.0
	queue_free()
