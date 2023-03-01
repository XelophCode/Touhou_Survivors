extends Node2D

func _ready():
	Signals.connect("show_right_click_tip",catch_show_right_click_tip)
	Signals.connect("not_enough_crystals",catch_not_enough_crystals)

func _process(delta):
	global_position.x = get_global_mouse_position().x + 2
	global_position.y = get_global_mouse_position().y + 6

func catch_show_right_click_tip(value):
	visible = value

func catch_not_enough_crystals():
	$AnimationPlayer.play("shake")
