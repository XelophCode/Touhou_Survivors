extends Node2D

@export var power : PackedScene
@export var faith : PackedScene
@export var score : PackedScene
var pickups : Array
var threat : float

func _ready():
	Signals.connect("spawn_pickup",spawn_power_item)
	Signals.connect("increase_threat",catch_increase_threat)
	pickups = [power,faith,score]

func spawn_power_item(spawn_location,pickup_type,tier):
	if randf_range(0,1) <= 0.8:
		var inst = pickups[pickup_type].instantiate()
		inst.position = spawn_location
		if tier == 1:
			inst.value = threat * 2
			inst.rainbow_outline = true
		add_child(inst)

func catch_increase_threat():
	threat += 1.0
