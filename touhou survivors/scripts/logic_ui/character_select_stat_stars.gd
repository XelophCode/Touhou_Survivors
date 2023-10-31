@tool
extends Node2D

@export_range(0,5) var stars : int = 0:
	set(value):
		stars = value
		if Engine.is_editor_hint():
			
			if value > 0:
				$fill.get_child(value-1).show()
			if value < 5:
				$fill.get_child(value).hide()
		

func _ready():
	if !Engine.is_editor_hint():
		for i in stars:
			$fill.get_child(i).show()
