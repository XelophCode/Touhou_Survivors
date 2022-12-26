extends item_base_class

var needles = preload("res://prefabs/item_spawnables/utilities/Persuasion_Needle_Main.tscn")
var needle_count:int = 0

func _on_timer_timeout():
	if needle_count < stack_count:
		get_parent().add_child(needles.instantiate())
		needle_count += 1
	else:
		queue_free()
