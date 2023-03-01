extends item_base_class

@export var keystone : PackedScene
var spawn_count:float = 8.0

func _ready():
	
	if alt_fire:
		spawn_count = 1.0
	
	for i in spawn_count:
		var inst = keystone.instantiate()
		inst.alt = alt_fire
		get_parent().call_deferred("add_child",inst)
		await get_tree().create_timer(0.2).timeout
	queue_free()
