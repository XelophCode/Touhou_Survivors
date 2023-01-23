extends item_base_class

@export var amulet : PackedScene
var amulets_spawned : int = 0
var max_amulets : int
@export var amulets_with_orb : int = 5
@export var amulets_without_orb : int = 1

func _ready():
	if occult_orb:
		max_amulets = amulets_with_orb
	else:
		max_amulets = amulets_without_orb

func _on_timer_timeout():
	if amulets_spawned < max_amulets:
		get_parent().add_child(amulet.instantiate())
		amulets_spawned += 1
	else:
		queue_free()
