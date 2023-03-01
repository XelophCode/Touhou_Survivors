extends item_base_class

@export var amulet : PackedScene
var amulets_spawned : float = 0
var max_amulets : float = 5.0
var spread : float = 15.0

func _ready():
	pass

func _on_timer_timeout():
	if amulets_spawned < max_amulets:
		var inst = amulet.instantiate()
		
		if alt_fire:
			inst.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing) + spread
			inst.alt = alt_fire
			spread -= 8.0
		
		get_parent().add_child(inst)
		amulets_spawned += 1.0
	else:
		queue_free()
