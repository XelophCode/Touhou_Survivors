extends Node

enum {RIGHT = 1, LEFT = -1, DOWN = 1, UP = -1, CENTER = 0}

var player_position:Vector2
var player_facing:Vector2 = Vector2(0,1)
var one_time_spawns:Array
var tooltip_info:Array = []
var photo_dest:Vector2

#USED IN CAMERA ITEM FOR GETTING RECT2 SCALE
func wind_mult():
	var mult:float
	match get_window_scale():
		1: mult = 1
		2: mult = 1.5
		3: mult = 2.25
		4: mult = 3
		5: mult = 4.5
	return mult

#USED IN CAMERA ITEM FOR GETTING RECT2 SCALE
func wind_div():
	var div:float
	match get_window_scale():
		1: div = 1
		2: div = 0.75
		3: div = 0.5
		4: div = 0.33
		5: div = 0.2
	return div

#CAN BE USED TO GET CURRENT RESOLUTION
func get_window_scale():
	var tier:int
	match get_window().get_size_with_decorations().y:
		279: tier = 1
		399: tier = 2
		519: tier = 3
		759: tier = 4
		1119: tier = 5
		1080: tier = 5
	return tier

func cardinal_direction_to_rotation(direction:Vector2):
	match direction:
		Vector2.RIGHT: return 0
		Vector2(RIGHT,UP): return -45
		Vector2.UP: return -90
		Vector2(LEFT,UP): return -135
		Vector2.LEFT: return -180
		Vector2(LEFT,DOWN): return -225
		Vector2.DOWN: return -270
		Vector2(DOWN,RIGHT): return -315
		Vector2.ZERO: return 0
