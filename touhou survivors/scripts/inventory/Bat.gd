extends item_base_class

var bat = preload("res://prefabs/item_spawnables/utilities/Bat_main.tscn")

func _ready():
	for i in stack_count:
		get_parent().call_deferred("add_child",bat.instantiate())
	queue_free()
