extends Node

enum {RIGHT = 1, LEFT = -1, DOWN = 1, UP = -1, CENTER = 0}

var player_position:Vector2
var player_facing:Vector2 = Vector2(0,1)
var one_time_spawns:Array
var tooltip_info:Array = []
var photo_dest:Vector2
enum {Reimu,Marisa}
var current_character:int = 0
var audio_reset:float
var player_hp:float
var crystal_count:float = 100.0
var holding_item:bool = false
var rand_id_assigns:Array

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
		749: tier = 4
		1119: tier = 5
		1080: tier = 5
		_: print("ERROR: NO MATCHING RESOLUTION '" + str(get_window().get_size_with_decorations().y) + "'")
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

func any_input():
	var key_pressed:bool = false
	var all_keys:Array = ["focus","move_left","move_right","move_up","move_down","left_mouse_button","right_mouse_button","rotate_item","select","focus","escape"]
	for key in all_keys:
		if Input.is_action_just_pressed(key):
			key_pressed = true
	return key_pressed

func random_color():
	var random_color_array:Array = []
	var color_1:float = randf_range(0,0.1)
	var color_2:float = randf_range(0.3,0.7)
	var color_3:float = randf_range(0.8,1.0)
	random_color_array.append(color_1)
	random_color_array.append(color_2)
	random_color_array.append(color_3)
	random_color_array.shuffle()
	return Color(random_color_array[0],random_color_array[1],random_color_array[2],1.0)

func pos_neg(value):
	var random_pos_neg:Array = [-1,1]
	random_pos_neg.shuffle()
	return value * random_pos_neg[0]
