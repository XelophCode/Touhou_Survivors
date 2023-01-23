extends item_base_class

@export var bomb : PackedScene
var spawn_count:int
@export var bombs_with_orb:int = 5
@export var bombs_without_orb:int = 1

func _ready():
	if occult_orb:
		spawn_count = bombs_with_orb
	else:
		spawn_count = bombs_without_orb
	for i in spawn_count:
		get_parent().call_deferred("add_child",bomb.instantiate())
	queue_free()
	
