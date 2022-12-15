extends Node2D


func _on_button_button_down():
	Globals.leveling_up = false
	Signals.emit_signal("leveling_up",false)
	queue_free()
