extends item_base_class

var doll = preload("res://prefabs/item_spawnables/utilities/Shanghai_Doll_Main.tscn")
var spawn_count:int
@export var dolls_with_orb:int = 8
@export var dolls_without_orb:int = 1

func _ready():
	if occult_orb:
		spawn_count = dolls_with_orb
	else:
		spawn_count = dolls_without_orb
	
	for i in spawn_count:
		get_parent().call_deferred("add_child",doll.instantiate())
		await get_tree().create_timer(0.05).timeout
	queue_free()
