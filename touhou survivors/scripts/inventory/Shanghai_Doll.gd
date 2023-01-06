extends item_base_class

var doll = preload("res://prefabs/item_spawnables/utilities/Shanghai_Doll_Main.tscn")

func _ready():
	for i in stack_count:
		get_parent().call_deferred("add_child",doll.instantiate())
		await get_tree().create_timer(0.05).timeout
	queue_free()
