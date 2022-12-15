extends item_base_class

@export var amulet : PackedScene
var amulets_spawned : int = 0
var max_amulets : int

func _ready():
	max_amulets = stack_count

func _on_timer_timeout():
	if amulets_spawned < max_amulets:
		get_parent().add_child(amulet.instantiate())
		amulets_spawned += 1
	else:
		queue_free()
