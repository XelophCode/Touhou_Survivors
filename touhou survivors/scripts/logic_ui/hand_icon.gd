extends Node2D

@export var collision_id : Node
@export var point : Sprite2D
@export var open_hand : Sprite2D
@export var closed_hand : Sprite2D

var cursor_move_speed : float = 3.0

var cursor_move_dir : Vector2
var hovering_item : bool = false
var mouse_relative : Vector2
var leveling_up : bool = false

func _ready():
	Signals.leveling_up.connect(func(value):
		leveling_up = value
		if value:
			global_position = Vector2(426/2,240/2)
			show()
		else:
			hide())
	
	Signals.show_closed_hand.connect(func(): show_closed_hand())
	Signals.show_open_hand.connect(func(): show_open_hand())


func _input(event):
	if event is InputEventMouseMotion:
		mouse_relative = event.relative


func _process(delta):
	if !leveling_up:
		return
	
	var combined_left : float = ceil(Input.get_action_raw_strength("dpad_left")) + Input.get_action_raw_strength("joystick_left")
	var combined_right : float = ceil(Input.get_action_raw_strength("dpad_right")) + Input.get_action_raw_strength("joystick_right")
	var combined_up : float = ceil(Input.get_action_raw_strength("dpad_up")) + Input.get_action_raw_strength("joystick_up")
	var combined_down : float = ceil(Input.get_action_raw_strength("dpad_down")) + Input.get_action_raw_strength("joystick_down")
	combined_left = clampf(combined_left,0,1.0)
	combined_right = clampf(combined_right,0,1.0)
	combined_up = clampf(combined_up,0,1.0)
	combined_down = clampf(combined_down,0,1.0)
	
	cursor_move_dir.x = combined_right - combined_left
	cursor_move_dir.y = combined_down - combined_up
	
	
	
	if abs(cursor_move_dir.x) < 0.1 and abs(cursor_move_dir.y) < 0.1:
		cursor_move_dir = Vector2.ZERO
	
	if Input.is_action_pressed("cursor_fast_move"):
		cursor_move_speed = 8.0
	else:
		cursor_move_speed = 3.0
	
	cursor_move_dir = cursor_move_dir * cursor_move_speed
	
	global_position += cursor_move_dir + mouse_relative
	
	global_position.x = clamp(global_position.x,0,426)
	global_position.y = clamp(global_position.y,0,240)
	
	Globals.hand_icon_position = global_position
	mouse_relative = Vector2.ZERO


func show_pointer():
	point.show()
	open_hand.hide()
	closed_hand.hide()


func show_closed_hand():
	closed_hand.show()
	open_hand.hide()
	point.hide()


func show_open_hand():
	open_hand.show()
	closed_hand.hide()
	point.hide()







