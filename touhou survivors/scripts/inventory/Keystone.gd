extends item_base_class

@export var keystone : PackedScene
var spawn_count:int
@export var keystones_with_orb:int = 3
@export var keystones_without_orb:int = 1

func _ready():
	if occult_orb:
		spawn_count = keystones_with_orb
	else:
		spawn_count = keystones_without_orb
	for i in spawn_count:
		get_parent().call_deferred("add_child",keystone.instantiate())
		await get_tree().create_timer(0.2).timeout
	queue_free()
