extends item_base_class

@export var amulet : PackedScene
var amulets_spawned : float = 0
var max_amulets : float = 5.0
var spread : float = 16.0
var spawn_count:float = 3.0

func _ready():
	if alt_fire:
		spawn_count = 8.0
	for i in spawn_count:
		var inst = amulet.instantiate()
		inst.alt = alt_fire
		
		if alt_fire:
			inst.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing) + spread
			spread -= 4.0
		
		get_parent().call_deferred("add_child",inst)
		await get_tree().create_timer(0.1).timeout
	queue_free()
