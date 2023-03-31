extends item_base_class

var spawn_amount:int = 8
@export var mushroom:PackedScene

func _ready():
	if alt_fire:
		spawn_amount = 5
	for i in spawn_amount:
		var mush_inst = mushroom.instantiate()
		mush_inst.alt = alt_fire
		get_parent().call_deferred("add_child",mush_inst)
		if alt_fire:
			await get_tree().create_timer(0.2).timeout
	queue_free()
