extends item_base_class

@export var raincloud:PackedScene
@export var tornado:PackedScene
var spawn_count:float = 3.0

func _ready():
	if alt_fire:
		var raincloud_inst = raincloud.instantiate()
		get_parent().call_deferred("add_child",raincloud_inst)
	else:
		Signals.emit_signal("tornado_sfx")
		for i in spawn_count:
			var tornado_inst = tornado.instantiate()
			get_parent().call_deferred("add_child",tornado_inst)
	queue_free()
