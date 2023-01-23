extends item_base_class

@export var bat : PackedScene

@export var bat_count_with_orb:int = 20
@export var bat_count_without_orb:int = 5

func _ready():
	
	if occult_orb:
		for i in bat_count_with_orb:
			get_parent().call_deferred("add_child",bat.instantiate())
	else:
		for i in bat_count_without_orb:
			get_parent().call_deferred("add_child",bat.instantiate())
	
	queue_free()
