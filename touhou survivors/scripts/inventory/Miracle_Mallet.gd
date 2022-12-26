extends Node2D

func _ready():
	Signals.emit_signal("modify_player_scale")
	queue_free()
