@tool
extends Node2D

@export_range(0,5) var count : int = 5:
	set(value):
		count = value
		if value > 0:
			get_child(value-1).show()
		if value < 5:
			get_child(value).hide()
