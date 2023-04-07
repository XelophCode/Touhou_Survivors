extends item_base_class

@export var arrow:PackedScene
var spawn_count:int = 7
var rot:float = 15.0

func _ready():
	if !alt_fire:
		Signals.emit_signal("arrow_sfx")
	for i in spawn_count:
		var arrow_inst = arrow.instantiate()
		if alt_fire:
			Signals.emit_signal("arrow_sfx")
			rot = randf_range(-3.0,3.0)
		arrow_inst.rot = rot
		get_parent().call_deferred("add_child",arrow_inst)
		rot -= 5.0
		if alt_fire:
			await get_tree().create_timer(0.1).timeout
	queue_free()
