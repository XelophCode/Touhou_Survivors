extends Node2D

var level:int = 1
var tier_one:Array = [1,2,3,8,9,10,15,16,17]
var tier_two:Array = [1,2,3,8,9,10,15,16,17,4,11,18,25,24,23,22]
var tier_three:Array = [1,2,3,8,9,10,15,16,17,4,11,18,25,24,23,22,5,12,19,26,33,32,31,30,29]
var tier_four:Array = [1,2,3,8,9,10,15,16,17,4,11,18,25,24,23,22,5,12,19,26,33,32,31,30,29,6,13,20,27,34,41,40,39,38,37,36]
var tier_five:Array = [1,2,3,8,9,10,15,16,17,4,11,18,25,24,23,22,5,12,19,26,33,32,31,30,29,6,13,20,27,34,41,40,39,38,37,36,7,14,21,28,35,42,49,48,47,46,45,44,43]
var current_tier:Array
var reimu_blocked_spaces:Array = [1,2,3,4,5,6,7,9,13,15,16,17,18,19,20,21,23,27,30,34,37,41,44,48]
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
	
	for i in reimu_blocked_spaces:
		var space = $InventoryGrid.get_child(i-1).get_child(0)
		space.blocked = true
		space.monitoring = false
		space.monitorable = false
	

func leveling_up(value:bool):
	if value:
		open_inventory()
		await get_tree().create_timer(1).timeout

	else:
		visible = false

func open_inventory():
	level += 1
	$AnimationPlayer.play("slide")
	visible = true

func slide_anim_finished():
	Signals.emit_signal("show_blocked_spaces")
