extends Node2D

@export var photo_texture : Node
@export var photo_border : Node
var text_val:float = 0.0
var alt:bool = false

func _ready():
	var tween = create_tween()
	tween.tween_property(self,"text_val",1.0,0.4)
	if alt:
		photo_border.rotation_degrees += 90
	

func _process(delta):
	global_position = lerp(global_position,Globals.photo_dest,delta*4)
	photo_texture.material.set_shader_parameter("texture_value",text_val)


func _on_timer_timeout():
	$AnimationPlayer.play("fade_out")
