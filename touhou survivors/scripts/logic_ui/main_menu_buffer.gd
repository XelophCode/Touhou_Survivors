extends Node2D

@export var main_menu : PackedScene

func _ready():
	get_tree().change_scene_to_packed(main_menu)
