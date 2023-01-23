extends item_base_class

@export var frog : PackedScene
var spawns : int = 0
var max_spawns : int
@export var frogs_with_orb:int = 6
@export var frogs_without_orb:int = 2

func _ready():
	if occult_orb:
		max_spawns = frogs_with_orb
	else:
		max_spawns = frogs_without_orb

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
