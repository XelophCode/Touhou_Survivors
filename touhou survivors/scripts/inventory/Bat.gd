extends item_base_class

@export var bat : PackedScene

@export var bat_count_with_orb:int = 20
@export var bat_count_without_orb:int = 5
var large_bat:bool = true

func _ready():
	if occult_orb:
		for i in bat_count_with_orb:
			var inst = bat.instantiate()
			inst.bat_type = "blood"
			inst.damage = 2
			inst.blood_trail = true
			if large_bat:
				inst.bat_type = "blood_large"
				inst.collision_scale = 2.0
				large_bat = false
			get_parent().call_deferred("add_child",inst)
	else:
		for i in bat_count_without_orb:
			var inst = bat.instantiate()
			inst.bat_type = "normal"
			inst.damage = 1
			get_parent().call_deferred("add_child",inst)
	
	queue_free()
