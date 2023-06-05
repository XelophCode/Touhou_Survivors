extends Node

enum {RIGHT = 1, LEFT = -1, DOWN = 1, UP = -1, CENTER = 0}

var player_position:Vector2
var player_facing:Vector2 = Vector2(0,1)
var one_time_spawns:Array
var tooltip_info:Array = []
var photo_dest:Vector2
enum {Reimu,Marisa,Remilia,Aya,Suika,Reisen,Youmu,Cirno}
var current_character:int = 0
var audio_reset:float
var player_hp:float
var crystal_count:float = 100.0
var holding_item:bool = false
var rand_id_assigns:Array
var player_z_index:float
var player_alive:bool = true
var screen_center:Vector2
var settings:Dictionary
var disabled_items:Array
var used_items:Array
var used_items_total:int
var used_spellcards:Array
var used_spellcards_total:int
var simul_spellcard:int
var all_spellcard:int = 0
var lilywhite:int = 0
var daiyousei:int = 0
var leveling_up:bool

const secondary_input:Array = ["interact"]
const app_version:String = "1.0.1"

const settings_file_path : String = "user://settings.dat"

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
		2: div = 0.6
		3: div = 0.4
		4: div = 0.33
		5: div = 0.2
		6: div = 0.15
	return div

#CAN BE USED TO GET CURRENT RESOLUTION
func get_window_scale():
	var tier:int
	match get_window().get_size_with_decorations().y:
		269: tier = 1
		389: tier = 2
		509: tier = 3
		749: tier = 4
		1080: tier = 5
		1109: tier = 5
		1469: tier = 5
		2189: tier = 6
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

func secondary_input_just_pressed():
	var key_pressed:bool = false
	for key in secondary_input:
		if Input.is_action_just_pressed(key):
			key_pressed = true
	return key_pressed

func secondary_input_just_released():
	var key_pressed:bool = false
	for key in secondary_input:
		if Input.is_action_just_released(key):
			key_pressed = true
	return key_pressed

func secondary_input_pressed():
	var key_pressed:bool = false
	for key in secondary_input:
		if Input.is_action_pressed(key):
			key_pressed = true
	return key_pressed

func secondary_input_released():
	var key_pressed:bool = false
	for key in secondary_input:
		if !Input.is_action_pressed(key):
			key_pressed = true
	return key_pressed

func any_input_just_pressed():
	var key_pressed:bool = false
	var all_keys:Array = ["focus","move_left","move_right","move_up","move_down","left_mouse_button","right_mouse_button","rotate_item","select","focus","escape"]
	for key in all_keys:
		if Input.is_action_just_pressed(key):
			key_pressed = true
	return key_pressed

func any_input_pressed():
	var key_pressed:bool = false
	var all_keys:Array = ["focus","move_left","move_right","move_up","move_down","left_mouse_button","right_mouse_button","rotate_item","select","focus","escape"]
	for key in all_keys:
		if Input.is_action_pressed(key):
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

#func item_code_to_alphabetical_order(code:int):
#	var new_code:int
#	match code:
#		0: pass

func item_code_to_string(code:int):
	var name_s:String
	match code:
		0: name_s = "Yinyang Orb"
		1: name_s = "Sake"
		2: name_s = "Gohei"
		3: name_s = "Roukanken"
		4: name_s = "Throwing Knife"
		5: name_s = "Rock"
		6: name_s = "Magic Broom"
		7: name_s = "Mini Hakkero"
		8: name_s = "Homing Amulet"
		9: name_s = "Frogs"
		10: name_s = "Haniwa"
		11: name_s = "Camera"
		12: name_s = "Miracle Mallet"
		13: name_s = "Persuasion Needles"
		14: name_s = "Icicle"
		15: name_s = "Youkai Umbrella"
		16: name_s = "Purification Rod"
		17: name_s = "Mochi Mallet"
		18: name_s = "Magic Bomb"
		19: name_s = "Shanghai Doll"
		20: name_s = "Bats"
		21: name_s = "Keystone"
		22: name_s = "Gap Umbrella"
		23: name_s = "Magic Tome"
		24: name_s = "Nature Wand"
		25: name_s = "Mushroom"
		26: name_s = "Megaphone Gun"
		27: name_s = "Lunar Bow"
		28: name_s = "Leaf Fan"
		29: name_s = "Tripod"
	
	return name_s


