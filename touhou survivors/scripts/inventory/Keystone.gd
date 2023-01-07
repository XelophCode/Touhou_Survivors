extends item_base_class

var keystone = preload("res://prefabs/item_spawnables/utilities/keystone_main.tscn")

func _ready():
	for i in stack_count:
		get_parent().call_deferred("add_child",keystone.instantiate())
		await get_tree().create_timer(0.2).timeout
	queue_free()
