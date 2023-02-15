extends Node2D

@export var main_menu_bg : Node

func _ready():
	$AnimationPlayer.play("fade_in")
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(main_menu_bg,"global_position",Vector2(0,480),5)
	
	var tween2 = create_tween().set_parallel()
	tween2.tween_property($AudioStreamPlayer,"volume_db",0.0,3)
