extends Node2D

var level:int = 19
var tier_one:Array = [1,2,3,8,9,10,15,16,17]
var tier_two:Array = [1,2,3,8,9,10,15,16,17,4,11,18,25,24,23,22]
var tier_three:Array = [1,2,3,8,9,10,15,16,17,4,11,18,25,24,23,22,5,12,19,26,33,32,31,30,29]
var tier_four:Array = [1,2,3,8,9,10,15,16,17,4,11,18,25,24,23,22,5,12,19,26,33,32,31,30,29,6,13,20,27,34,41,40,39,38,37,36]
var tier_five:Array = [1,2,3,8,9,10,15,16,17,4,11,18,25,24,23,22,5,12,19,26,33,32,31,30,29,6,13,20,27,34,41,40,39,38,37,36,7,14,21,28,35,42,49,48,47,46,45,44,43]
var current_tier:Array
@export var blocked_spaces_tier_2 : Texture
@export var blocked_spaces_tier_3 : Texture
@export var blocked_spaces_tier_4 : Texture
@export var blocked_spaces : Node
@export var character_art : Node
@export var grid_art : Node
@export var reimu_char_art : Texture2D
@export var marisa_char_art : Texture2D

func _ready():
	match Globals.current_character:
		Globals.Reimu: character_art.texture = reimu_char_art
		Globals.Marisa: character_art.texture = marisa_char_art
	Signals.connect("leveling_up",leveling_up)
	current_tier = tier_one
	for area in $InventoryGrid.get_children():
		var space = area.get_child(0)
		space.monitorable = false
		space.monitoring = false

func leveling_up(value:bool):
	if value:
		open_inventory()
	else:
		visible = false
		for i in current_tier:
			var space = $InventoryGrid.get_child(i-1).get_child(0)
			space.monitorable = false
			space.monitoring = false

func open_inventory():
#	global_position.x = Globals.player_position.x + 100
#	global_position.y = Globals.player_position.y
	level += 1
	match level:
		5: current_tier = tier_two; blocked_spaces.texture = blocked_spaces_tier_2
		10: current_tier = tier_three; blocked_spaces.texture = blocked_spaces_tier_3
		15: current_tier = tier_four; blocked_spaces.texture = blocked_spaces_tier_4
		20: current_tier = tier_five; blocked_spaces.visible = false
		_:pass
	
	$AnimationPlayer.play("slide")
	visible = true
	for i in current_tier:
		var space = $InventoryGrid.get_child(i-1).get_child(0)
		space.set_deferred("monitorable",true)
		space.set_deferred("monitoring",true)
