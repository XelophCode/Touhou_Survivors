extends Node2D

var value:float = 1

func _on_area_2d_body_entered(_body):
	Signals.emit_signal("update_power", value)
	queue_free()
