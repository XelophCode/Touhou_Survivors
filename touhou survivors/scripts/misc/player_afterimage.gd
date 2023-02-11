extends Node2D

@export var player_afterimage : PackedScene

func _ready():
	Signals.connect("update_afterimage",catch_update_afterimage)

func catch_update_afterimage(animation,frame,fliph):
	var inst = player_afterimage.instantiate()
	inst.animation = animation
	inst.frame = frame
	inst.flip_h = fliph
	inst.global_position = Globals.player_position
	add_child(inst)
