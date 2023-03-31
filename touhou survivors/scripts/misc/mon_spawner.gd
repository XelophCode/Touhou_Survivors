extends Node2D

@export var mon:PackedScene
var spawn_count:int = randi_range(1,3)

func _ready():
	Signals.connect("spawn_mon",catch_spawn_mon)

func catch_spawn_mon(location):
	for i in spawn_count:
		var mon_inst = mon.instantiate()
		mon_inst.global_position = location
		add_child(mon_inst)
	
