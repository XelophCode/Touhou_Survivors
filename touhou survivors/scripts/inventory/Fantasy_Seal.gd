extends item_base_class

@export var orb:PackedScene

var spawn_count:float = 7.0

func _ready():
	
	for i in spawn_count:
		var orb_inst = orb.instantiate()
		get_parent().call_deferred("add_child",orb_inst)
		await get_tree().create_timer(0.3).timeout
	queue_free()
