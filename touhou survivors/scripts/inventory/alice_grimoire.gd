extends item_base_class

@export var grimoire:PackedScene
var spawn_count:float = 8.0

func _ready():
	for i in spawn_count:
		var grimoire_inst = grimoire.instantiate()
		get_parent().call_deferred("add_child",grimoire_inst)
		await get_tree().create_timer(0.3).timeout
	queue_free()
