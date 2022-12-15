extends Node2D


func _on_timer_timeout():
	Signals.emit_signal("despawn_offscreen_enemies")
