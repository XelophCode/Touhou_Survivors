extends Node2D

@export var player_afterimage : PackedScene

func _ready():
	Signals.connect("update_afterimage",catch_update_afterimage)

func catch_update_afterimage(sprite_frames,animation,frame,fliph,player_scale:float):
	var inst = player_afterimage.instantiate()
	inst.sprite_frames = sprite_frames
	inst.animation = animation
	inst.frame = frame
	inst.flip_h = fliph
	inst.global_position = Globals.player_position
	inst.scale = Vector2(player_scale+0.1,player_scale+0.1)
	add_child(inst)
