extends Node2D

var rotation_deg:Array = [0,90,180,270]

func _ready():
	rotation = deg_to_rad(rotation_deg.pick_random())
	for element in $elements.get_children():
		element.rotation = -rotation

