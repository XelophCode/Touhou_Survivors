extends Node2D

func _ready():
	Signals.connect("spawn_bullet",catch_spawn_bullet)

func catch_spawn_bullet(bullet):
	add_child(bullet)
