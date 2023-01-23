extends item_base_class

@export var needles : PackedScene
var needle_count:int = 0
var spawn_count:int
@export var needles_with_orb:int = 8
@export var needles_without_orb:int = 3

func _on_timer_timeout():
	if occult_orb:
		spawn_count = needles_with_orb
	else:
		spawn_count = needles_without_orb
	if needle_count < spawn_count:
		get_parent().add_child(needles.instantiate())
		needle_count += 1
	else:
		queue_free()
