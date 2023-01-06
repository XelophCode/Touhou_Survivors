extends Node2D

var power = preload("res://prefabs/misc/power.tscn")

func _ready():
	Signals.connect("spawn_power_item",spawn_power_item)

func spawn_power_item(spawn_location):
	if randi_range(1,1) == 1:
		var inst = power.instantiate()
		inst.position = spawn_location
		add_child(inst)
