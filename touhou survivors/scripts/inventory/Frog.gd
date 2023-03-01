extends item_base_class

@export var frog : PackedScene
var spawns : float = 0
var max_spawns : float = 6.0

func _ready():
	pass

func _process(_delta):
	global_position = Globals.player_position

func _on_timer_timeout():
	if spawns < max_spawns:
		var spawn_frog = frog.instantiate()
		spawn_frog.global_position = global_position
		spawn_frog.alt = alt_fire
		get_parent().add_child(spawn_frog)
		spawns += 1.0
	else:
		queue_free()
