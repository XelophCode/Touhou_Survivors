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
	
	if update_tag:
		if hide_descriptions:
			$Label.text = item_name + " (" + stack_amt + "/" + stack_limit + ")"
		else:
			$Label.text = item_name + " (" + stack_amt + "/" + stack_limit + ")" + "\n" + item_desc
		update_tag = false
		
	global_position.x = get_global_mouse_position().x + 4
	global_position.y = get_global_mouse_position().y

func show_tooltip(weapon_name,stack_count,stack_max,item_description):
	visible = true
	item_name = weapon_name
	stack_amt = str(stack_count)
	stack_limit = str(stack_max)
	item_desc = item_description
	update_tag = true
	
	

func hide_tooltip():
	visible = false
