extends item_base_class

@export var knife:PackedScene
var spawn_count:float = 8.0
var rot_amt:float

func _ready():
	if alt_fire:
		rot_amt = 20.0
		spawn_count = 4.0
	for i in spawn_count:
		var knife_inst = knife.instantiate()
		knife_inst.rot = rot_amt
		knife_inst.alt = alt_fire
		get_parent().call_deferred("add_child",knife_inst)
		if alt_fire:
			rot_amt -= 10.0
		else:
			rot_amt -= 45.0
		await get_tree().create_timer(0.05).timeout
	
	queue_free()
