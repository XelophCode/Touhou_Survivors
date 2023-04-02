extends item_base_class

@export var bullet:PackedScene
@export var shockwave:PackedScene
var spawn_count:int = 7
var rot:float = 30.0

func _ready():
	if alt_fire:
		var shockwave_inst = shockwave.instantiate()
		get_parent().call_deferred("add_child",shockwave_inst)
	else:
		for i in spawn_count:
			var bullet_inst = bullet.instantiate()
			bullet_inst.rot = rot
			get_parent().call_deferred("add_child",bullet_inst)
			rot -= 10.0
			await get_tree().create_timer(0.1).timeout
	queue_free()
