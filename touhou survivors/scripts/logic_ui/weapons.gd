extends Node2D

func _ready():
	Signals.connect("weapon_add_child",catch_weapon_add_child)

func catch_weapon_add_child(inst):
	add_child(inst)
