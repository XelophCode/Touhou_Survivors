extends item_base_class

@export var spin:PackedScene
@export var swing:PackedScene
var spawn_count:int = 8

func _ready():
	if alt_fire:
		for i in spawn_count:
			var spin_inst = spin.instantiate()
			get_parent().call_deferred("add_child",spin_inst)
			await get_tree().create_timer(0.05).timeout
	else:
		var swing_inst = swing.instantiate()
		get_parent().call_deferred("add_child",swing_inst)
	queue_free()
