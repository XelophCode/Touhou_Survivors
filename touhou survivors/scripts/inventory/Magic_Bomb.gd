extends item_base_class

@export var bomb : PackedScene
var spawn_count:float = 3.0

func _ready():
	for i in spawn_count:
		var bomb_inst = bomb.instantiate()
		bomb_inst.alt = alt_fire
		get_parent().call_deferred("add_child",bomb_inst)
		if !alt_fire:
			await get_tree().create_timer(0.5).timeout
	queue_free()
	
