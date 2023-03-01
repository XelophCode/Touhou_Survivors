extends item_base_class

@export var bat : PackedScene

@export var bat_count_with_orb:int = 20
@export var bat_count_without_orb:int = 6
var large_bat:bool = true
var left_right:bool = false

func _ready():
	if alt_fire:
		for i in bat_count_without_orb:
			var inst = bat.instantiate()
			inst.bat_type = "normal"
			inst.damage = 1
			inst.alt = true
			left_right = !left_right
			inst.left_right = left_right
			get_parent().call_deferred("add_child",inst)
	else:
		for i in bat_count_without_orb:
			var inst = bat.instantiate()
			inst.bat_type = "normal"
			inst.damage = 1
			get_parent().call_deferred("add_child",inst)
	
	queue_free()
