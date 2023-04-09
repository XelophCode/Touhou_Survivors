extends Node2D

var hide_descriptions : bool = false
var item_name : String = ""
var stack_amt : String = ""
var stack_limit : String = ""
var item_desc : String = ""
var update_tag : bool = false
var show_desc : bool = false

@export var label:Label

func _ready():
	Signals.connect("show_tooltip",show_tooltip)
	Signals.connect("hide_tooltip",hide_tooltip)
	Signals.connect("leveling_up",catch_leveling_up)

func _process(_delta):
	if Input.is_action_just_pressed("hide_descriptions"):
		if show_desc == true:
			visible = true
	if Input.is_action_just_released("hide_descriptions"):
		visible = false
	
#	if visible:
#		print(str(position))
#	if Input.is_action_just_pressed("hide_descriptions"):
#		if hide_descriptions:
#			hide_descriptions = false
#			update_tag = true
#		else:
#			hide_descriptions = true
#			update_tag = true
	
	if update_tag and Globals.tooltip_info != []:
		if hide_descriptions:
			$Label.text = Globals.tooltip_info[0][0]
		else:
			$Label.text = Globals.tooltip_info[0][0] + "\n" + Globals.tooltip_info[0][1]
		update_tag = false
	
	global_position.x = get_global_mouse_position().x + 4
	global_position.y = get_global_mouse_position().y + 4
	
	if visible:
		#print(str(position.x + label.size.x))
		if position.x + label.size.x >= 426.0:
			global_position.x = (get_global_mouse_position().x + 4) - ((position.x + label.size.x) - 426.0)
			#print("OUT OF RANGE")

func hide_tooltip():
	show_desc = false
	visible = false

func show_tooltip():
	show_desc = true
	update_tag = true

func catch_leveling_up(value):
	if !value:
		visible = false
