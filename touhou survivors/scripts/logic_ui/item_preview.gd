extends Node2D

@export var video_player : VideoStreamPlayer
@export var video_sprite : Sprite2D
@export var name_label : Label
@export var damage_label : Label

@export_group("videos")
@export var bats_a:Resource
@export var bats_b:Resource
@export var camera_a:Resource
@export var camera_b:Resource
@export var frog_a:Resource
@export var frog_b:Resource
@export var gohei_a:Resource
@export var gohei_b:Resource
@export var haniwa_a:Resource
@export var haniwa_b:Resource
@export var homing_amulet_a:Resource
@export var homing_amulet_b:Resource
@export var icicle_a:Resource
@export var icicle_b:Resource
@export var keystone_a:Resource
@export var keystone_b:Resource
@export var leaf_fan_a:Resource
@export var leaf_fan_b:Resource
@export var lunar_bow_a:Resource
@export var lunar_bow_b:Resource
@export var magic_bomb_a:Resource
@export var magic_bomb_b:Resource
@export var magic_broom_a:Resource
@export var magic_broom_b:Resource
@export var magic_tome_a:Resource
@export var magic_tome_b:Resource
@export var megaphone_gun_a:Resource
@export var megaphone_gun_b:Resource
@export var mini_hakkero_a:Resource
@export var mini_hakkero_b:Resource
@export var mochi_mallet_a:Resource
@export var mochi_mallet_b:Resource
@export var mushroom_a:Resource
@export var mushroom_b:Resource
@export var nature_wand_a:Resource
@export var nature_wand_b:Resource
@export var persuasion_needles_a:Resource
@export var persuasion_needles_b:Resource
@export var purification_rod_a:Resource
@export var purification_rod_b:Resource
@export var roukanken_a:Resource
@export var roukanken_b:Resource
@export var sake_a:Resource
@export var sake_b:Resource
@export var shanghai_doll_a:Resource
@export var shanghai_doll_b:Resource
@export var throwing_knife_a:Resource
@export var throwing_knife_b:Resource
@export var tripod_a:Resource
@export var tripod_b:Resource
@export var yinyang_orb_a:Resource
@export var yinyang_orb_b:Resource
@export var youkai_umbrella_a:Resource
@export var youkai_umbrella_b:Resource



func _ready():
	Signals.item_video.connect(catch_item_video)
	Signals.hide_video.connect(catch_hide_video)
	

func _process(_delta):
	if visible:
		if Globals.secondary_input_just_released():
			visible = false
			video_player.stop()
	
	global_position.x = get_global_mouse_position().x + 60
	global_position.y = get_global_mouse_position().y
	
	if get_global_mouse_position().x >= 310.0:
		global_position.x = get_global_mouse_position().x - 60

func catch_item_video(item_name:int,rotated:bool):
	var video_selection:Resource
	match Globals.item_code_to_string(item_name):
		"Bats": 
			video_selection = bats_a ; name_label.text = "Bats |A|" ; damage_label.text = "1-2"
			if rotated: video_selection = bats_b ; name_label.text = "Bats |B|" ; damage_label.text = "1-2"
		"Camera": 
			video_selection = camera_a ; name_label.text = "Camera |A|" ; damage_label.text = "4-5"
			if rotated: video_selection = camera_b ; name_label.text = "Camera |B|" ; damage_label.text = "4-5"
		"Frogs": 
			video_selection = frog_a ; name_label.text = "Frogs |A|" ; damage_label.text = "1-2"
			if rotated: video_selection = frog_b ; name_label.text = "Frogs |B|" ; damage_label.text = "2-3"
		"Gohei": 
			video_selection = gohei_a ; name_label.text = "Gohei |A|" ; damage_label.text = "13-17"
			if rotated: video_selection = gohei_b ; name_label.text = "Gohei |B|" ; damage_label.text = "13-17"
		"Haniwa": 
			video_selection = haniwa_a ; name_label.text = "Haniwa |A|" ; damage_label.text = "8-10"
			if rotated: video_selection = haniwa_b ; name_label.text = "Haniwa |B|" ; damage_label.text = "8-10"
		"Homing Amulet": 
			video_selection = homing_amulet_a ; name_label.text = "Sealing Amulet |A|" ; damage_label.text = "1-2"
			if rotated: video_selection = homing_amulet_b ; name_label.text = "Sealing Amulet |B|" ; damage_label.text = "1-2"
		"Icicle": 
			video_selection = icicle_a ; name_label.text = "Icicle |A|" ; damage_label.text = "12-17"
			if rotated: video_selection = icicle_b ; name_label.text = "Icicle |B|" ; damage_label.text = "12-17"
		"Keystone": 
			video_selection = keystone_a ; name_label.text = "Keystone |A|" ; damage_label.text = "8-10"
			if rotated: video_selection = keystone_b ; name_label.text = "Keystone |B|" ; damage_label.text = "30-35"
		"Leaf Fan": 
			video_selection = leaf_fan_a ; name_label.text = "Leaf Fan |A|" ; damage_label.text = "3-5"
			if rotated: video_selection = leaf_fan_b ; name_label.text = "Leaf Fan |B|" ; damage_label.text = "3-5"
		"Lunar Bow": 
			video_selection = lunar_bow_a ; name_label.text = "Lunar Bow |A|" ; damage_label.text = "12-16"
			if rotated: video_selection = lunar_bow_b ; name_label.text = "Lunar Bow |B|" ; damage_label.text = "12-16"
		"Magic Bomb": 
			video_selection = magic_bomb_a ; name_label.text = "Magic Bomb |A|" ; damage_label.text = "8-12"
			if rotated: video_selection = magic_bomb_b ; name_label.text = "Magic Bomb |B|" ; damage_label.text = "8-12"
		"Magic Broom": 
			video_selection = magic_broom_a ; name_label.text = "Magic Broom |A|" ; damage_label.text = "7-10"
			if rotated: video_selection = magic_broom_b ; name_label.text = "Magic Broom |B|" ; damage_label.text = "7-10"
		"Magic Tome": 
			video_selection = magic_tome_a ; name_label.text = "Magic Tome |A|" ; damage_label.text = "8-12"
			if rotated: video_selection = magic_tome_b ; name_label.text = "Magic Tome |B|" ; damage_label.text = "9-12"
		"Megaphone Gun": 
			video_selection = megaphone_gun_a ; name_label.text = "Megaphone Gun |A|" ; damage_label.text = "7-10"
			if rotated: video_selection = megaphone_gun_b ; name_label.text = "Megaphone Gun |B|" ; damage_label.text = "5-7"
		"Mini Hakkero": 
			video_selection = mini_hakkero_a ; name_label.text = "Mini Hakkero |A|" ; damage_label.text = "12-15"
			if rotated: video_selection = mini_hakkero_b ; name_label.text = "Mini Hakkero |B|" ; damage_label.text = "12-15"
		"Mochi Mallet": 
			video_selection = mochi_mallet_a ; name_label.text = "Mochi Mallet |A|" ; damage_label.text = "12-17"
			if rotated: video_selection = mochi_mallet_b ; name_label.text = "Mochi Mallet |B|" ; damage_label.text = "12-17"
		"Mushroom": 
			video_selection = mushroom_a ; name_label.text = "Mushroom |A|" ; damage_label.text = "2-3"
			if rotated: video_selection = mushroom_b ; name_label.text = "Mushroom |B|" ; damage_label.text = "2-3"
		"Nature Wand": 
			video_selection = nature_wand_a ; name_label.text = "Nature Wand |A|" ; damage_label.text = "6-9"
			if rotated: video_selection = nature_wand_b ; name_label.text = "Nature Wand |B|" ; damage_label.text = "10-12"
		"Persuasion Needles": 
			video_selection = persuasion_needles_a ; name_label.text = "Persuasion Needles |A|" ; damage_label.text = "1-2"
			if rotated: video_selection = persuasion_needles_b ; name_label.text = "Persuasion Needles |B|" ; damage_label.text = "1-2"
		"Purification Rod": 
			video_selection = purification_rod_a ; name_label.text = "Purification Rod |A|" ; damage_label.text = "6-8"
			if rotated: video_selection = purification_rod_b ; name_label.text = "Purification Rod |B|" ; damage_label.text = "6-8"
		"Roukanken": 
			video_selection = roukanken_a ; name_label.text = "Roukanken |A|" ; damage_label.text = "8-10"
			if rotated: video_selection = roukanken_b ; name_label.text = "Roukanken |B|" ; damage_label.text = "8-10"
		"Sake": 
			video_selection = sake_a ; name_label.text = "Sake |A|" ; damage_label.text = "12-17"
			if rotated: video_selection = sake_b ; name_label.text = "Sake |B|" ; damage_label.text = "10-15"
		"Shanghai Doll": 
			video_selection = shanghai_doll_a ; name_label.text = "Shanghai Doll |A|" ; damage_label.text = "1-2"
			if rotated: video_selection = shanghai_doll_b ; name_label.text = "Shanghai Doll |B|" ; damage_label.text = "1-2"
		"Throwing Knife": 
			video_selection = throwing_knife_a ; name_label.text = "Throwing Knife |A|" ; damage_label.text = "3-5"
			if rotated: video_selection = throwing_knife_b ; name_label.text = "Throwing Knife |B|" ; damage_label.text = "3-5"
		"Tripod": 
			video_selection = tripod_a ; name_label.text = "Tripod |A|" ; damage_label.text = "16-19"
			if rotated: video_selection = tripod_b ; name_label.text = "Tripod |B|" ; damage_label.text = "16-19"
		"Yinyang Orb": 
			video_selection = yinyang_orb_a ; name_label.text = "Yinyang Orb |A|" ; damage_label.text = "8-12"
			if rotated: video_selection = yinyang_orb_b ; name_label.text = "Yinyang Orb |B|" ; damage_label.text = "8-12"
		"Youkai Umbrella": 
			video_selection = youkai_umbrella_a ; name_label.text = "Youkai Umbrella |A|" ; damage_label.text = "19-21"
			if rotated: video_selection = youkai_umbrella_b ; name_label.text = "Youkai Umbrella |B|" ; damage_label.text = "15-17"
		_: print("INVALID ITEM NAME: " + Globals.item_code_to_string(item_name))
	
	video_player.stream = video_selection
	video_player.play()
	
	
	visible = true

func catch_hide_video():
	visible = false
	video_player.stop()
	

func _on_video_stream_player_finished():
	video_player.play()
