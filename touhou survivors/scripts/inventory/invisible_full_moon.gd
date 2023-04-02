extends item_base_class

@export var bullet:PackedScene
var spawn_count:int = 100
var flip:bool = false
var rot_1:float = 90.0
var rot_2:float = 90.0

func _ready():
	for i in spawn_count:
		var rot:float
		var bullet_inst = bullet.instantiate()
		flip = !flip
		if flip:
			rot = rot_1
			rot_1 -= 15.0
		else:
			rot = rot_2
			rot_2 += 15.0
		bullet_inst.rot = rot
		get_parent().call_deferred("add_child",bullet_inst)
		await get_tree().create_timer(0.025).timeout
	queue_free()
