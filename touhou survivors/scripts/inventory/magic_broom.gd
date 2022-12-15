extends Node2D

func _ready():
	Signals.emit_signal("modify_player_speed",2)


func _on_tree_exiting():
	Signals.emit_signal("modify_player_speed",0.5)
