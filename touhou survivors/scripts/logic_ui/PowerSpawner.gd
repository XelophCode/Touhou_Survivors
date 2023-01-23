extends Node2D

@export var power : PackedScene
@export var faith : PackedScene
@export var score : PackedScene
var pickups : Array

func _ready():
	Signals.connect("spawn_pickup",spawn_power_item)
	pickups = [power,faith,score]

func spawn_power_item(spawn_location,pickup_type):
	if randf_range(0,1) <= 0.8:
		var inst = pickups[pickup_type].instantiate()
		inst.position = spawn_location
		add_child(inst)
