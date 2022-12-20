extends item_base_class

@export var frog : PackedScene
var spawns : int = 0
var max_spawns : int

func _ready():
	max_spawns = stack_count

func _physics_process(_delta):
	global_position = Globals.player_position

func _on_timer_timeout():
	if spawns < max_spawns:
		var spawn_frog = frog.instantiate()
		spawn_frog.global_position = global_position
		get_parent().add_child(spawn_frog)
		spawns += 1
	else:
		queue_free()
