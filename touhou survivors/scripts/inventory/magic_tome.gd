extends item_base_class

@export var fireball:PackedScene
@export var water_splash:PackedScene

func _ready():
	
	if alt_fire:
		var water_inst = water_splash.instantiate()
		get_parent().call_deferred("add_child",water_inst)
	else:
		var fireball_inst = fireball.instantiate()
		get_parent().call_deferred("add_child",fireball_inst)
	queue_free()
