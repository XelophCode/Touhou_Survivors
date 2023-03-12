extends item_base_class

var doll = preload("res://prefabs/item_spawnables/utilities/Shanghai_Doll_Main.tscn")
var spawn_count:float = 4.0

func _ready():
	
	for i in spawn_count:
		var doll_inst = doll.instantiate()
		doll_inst.shanghai_id = i
		doll_inst.alt = alt_fire
		get_parent().call_deferred("add_child",doll_inst)
		await get_tree().create_timer(0.05).timeout
	queue_free()
