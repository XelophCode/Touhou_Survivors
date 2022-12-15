extends Node2D

var value:int
var pos:Vector2

func _ready():
	$Node2D/Label.text = str(value)
	$AnimationPlayer.play("popup")

func _process(_delta):
	global_position = pos

func animation_complete():
	queue_free()
