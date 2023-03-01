extends item_base_class

@export var needles : PackedScene
var needle_count:float
var spawn_count:float = 3.0

func _on_timer_timeout():
	if needle_count < spawn_count:
		var needle_inst = needles.instantiate()
		needle_inst.alt = alt_fire
		get_parent().add_child(needle_inst)
		needle_count += 1
	else:
		queue_free()
