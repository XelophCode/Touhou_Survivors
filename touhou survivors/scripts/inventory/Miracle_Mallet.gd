extends Node2D

func _ready():
	Signals.emit_signal("modify_player_scale",2.0,2.0)

func _on_tree_exiting():
	Signals.emit_signal("modify_player_scale",1.0,0.5)
