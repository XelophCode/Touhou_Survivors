extends item_base_class

@export var leaf:PackedScene
var spawn_count:int = 10

func _ready():
	Signals.emit_signal("leaf_fan_sfx")
	for i in spawn_count:
		var leaf_inst = leaf.instantiate()
		leaf_inst.alt = alt_fire
		get_parent().call_deferred("add_child",leaf_inst)
	queue_free()
	
