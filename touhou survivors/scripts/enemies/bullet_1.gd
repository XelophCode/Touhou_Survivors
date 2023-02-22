extends Node2D

@export var sprite : Texture2D
@export var sin_curve : Curve
var frequency:float
var amplitude:float
var speed:float = 1.0
var damage:float = 1.0
var leveling_up:bool = false
var spiral_strength:float = 0
var time:float

func _ready():
	Signals.connect("leveling_up",catch_leveling_up)

func _process(delta):
	
	
	var move = speed
	if leveling_up:
		move = 0
	else:
		time += delta
		if spiral_strength != 0:
			rotation_degrees += delta * spiral_strength
		if amplitude > 0:
			var ymove = cos(time*frequency)*amplitude
			$main_body.position.y += ymove * delta
	
	$main_body.translate(Vector2(move,0))
	
	

func catch_leveling_up(value:bool):
	leveling_up = value
