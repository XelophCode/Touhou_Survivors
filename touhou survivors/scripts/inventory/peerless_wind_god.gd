extends item_base_class

@export var wind:PackedScene
var spawn_count:int = 16

func _ready():
	for i in spawn_count:
		var wind_inst = wind.instantiate()
		get_parent().call_deferred("add_child",wind_inst)
		await get_tree().create_timer(0.05).timeout
	queue_free()

