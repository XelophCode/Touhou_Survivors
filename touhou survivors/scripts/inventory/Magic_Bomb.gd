extends item_base_class

var bomb = preload("res://prefabs/item_spawnables/utilities/magic_bomb_main.tscn")

func _ready():
	for i in stack_count:
		get_parent().call_deferred("add_child",bomb.instantiate())
	queue_free()
	
