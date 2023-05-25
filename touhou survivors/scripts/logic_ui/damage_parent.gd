extends Node2D

func _ready():
	Signals.damage_popup_spawn.connect(catch_damage_popup_spawn)

func catch_damage_popup_spawn(inst):
	add_child(inst)
