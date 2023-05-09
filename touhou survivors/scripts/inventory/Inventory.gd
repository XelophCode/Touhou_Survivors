extends Node2D

var level:int = 1
var reimu_blocked_spaces:Array = [1,2,3,4,5,6,7,9,13,15,16,17,18,19,20,21,23,27,30,34,37,41,44,48]
var cross_blocked_spaces:Array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,20,21,22,23,25,27,28,29,30,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49]
@export var blocked_spaces : Node
@export var character_art : Node
@export var grid_art : Node
@export var reimu_char_art : Texture2D
@export var marisa_char_art : Texture2D
@export var remilia_char_art : Texture2D
@export var aya_char_art : Texture2D
@export var suika_char_art : Texture2D
@export var reisen_char_art : Texture2D
@export var youmu_char_art : Texture2D
@export var cirno_char_art : Texture2D

func _ready():
	match Globals.current_character:
		Globals.Reimu: character_art.texture = reimu_char_art
		Globals.Marisa: character_art.texture = marisa_char_art
		Globals.Remilia: character_art.texture = remilia_char_art
		Globals.Aya: character_art.texture = aya_char_art
		Globals.Suika: character_art.texture = suika_char_art
		Globals.Reisen: character_art.texture = reisen_char_art
		Globals.Youmu: character_art.texture = youmu_char_art
		Globals.Cirno: character_art.texture = cirno_char_art
	Signals.connect("leveling_up",leveling_up)
	
	for i in cross_blocked_spaces:
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
