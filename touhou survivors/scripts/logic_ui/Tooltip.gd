extends Node2D

var hide_descriptions : bool = true
var item_name : String = ""
var stack_amt : String = ""
var stack_limit : String = ""
var item_desc : String = ""
var update_tag : bool = false

func _ready():
	Signals.connect("show_tooltip",show_tooltip)
	Signals.connect("hide_tooltip",hide_tooltip)

func _process(_delta):
	if Input.is_action_just_pressed("hide_descriptions"):
		if hide_descriptions:
			hide_descriptions = false
			update_tag = true
		else:
			hide_descriptions = true
			update_tag = true
	
	if update_tag and Globals.tooltip_info != []:
		if hide_descriptions:
			$Label.text = Globals.tooltip_info[0][0]
		else:
			$Label.text = Globals.tooltip_info[0][0] + "\n" + Globals.tooltip_info[0][1]
		update_tag = false
		
	global_position.x = get_global_mouse_position().x + 4
	global_position.y = get_global_mouse_position().y

func hide_tooltip():
	visible = false

func show_tooltip():
	visible = true
	update_tag = true


