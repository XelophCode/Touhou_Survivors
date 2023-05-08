extends Node2D

@export var mon:PackedScene


func _ready():
	Signals.connect("spawn_mon",catch_spawn_mon)

func catch_spawn_mon(location):
	var spawn_count:int = randi_range(0,1)
	if spawn_count == 0:
		return
	else:
		var mon_inst = mon.instantiate()
		mon_inst.global_position = location
		add_child(mon_inst)
	
