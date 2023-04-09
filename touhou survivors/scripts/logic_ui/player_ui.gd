extends CanvasLayer

@export var main_menu : PackedScene
@export var character_portrait : Node
@export var time_label : Node
@export var lvl_label : Node
@export var powerbar : Node
@export var confetti : Node
@export var reimu_portrait : SpriteFrames
@export var marisa_portrait : SpriteFrames
@export var q_button_prompt : Node2D
@export var r_button_prompt : Node2D
@export var inven_button_prompts : Node2D
@export var main_menu_packed : PackedScene

@export_group("gameover")
@export_subgroup("time")
@export var time_survived_label:Label
@export var final_time_label:Label
@export_subgroup("enemy")
@export var killed_by_text : Node
@export var enemy_name : Node
@export var enemy_sprite : Node
@export_subgroup("pickups")
@export var pickups_label:Label
@export var faith_label:Label
@export var crystals_label:Label
@export var mon_label:Label
@export_subgroup("main_menu")
@export var any_button_label:Label

var time:float
var music_muted:bool = false
var playtime_second:float
var playtime_minute:float
var power:float
var power_update:float
var faith:float
var faith_update:float
var current_orb_target:int
var leveling_up:bool = false
var occult_orb_max:float = 10.0
var current_lvl:int = 1
var escape_can_unpause:bool = false
var crystal:float
var crystal_count:float
var killed_by:String = "Killed By:"
var time_survived:String = "Time Survived:"
var pickups_gathered:String = "Pickups Gathered:"
var final_time:String
var gameover_info:enemy_info
var skip_anims:bool = false
var can_skip_anims:bool = false
var game_over_mon:int
var current_crystal:float
var current_faith:float
var final_crystal:float
var final_faith:float
var is_gameover:bool = false

var mon:int:
	set(value):
		mon = value
		mon = clamp(mon,0,9999999)
		var mon_str = str(mon)
		Signals.emit_signal("mon_sfx")
		for i in mon_str.length():
			var old_txt:String = $UI/mon_labels.get_child(i).text
			
			$UI/mon_labels.get_child(i).visible = true
			$UI/mon_labels.get_child(i).text = mon_str[mon_str.length()-i-1]
			
			if old_txt != $UI/mon_labels.get_child(i).text:
				$mon_anims.get_child(i).play("default")

var is_paused:bool = false:
	set(value):
		is_paused = value
		if is_paused:
			$PauseMenu/pause_anims.play("slide_in")
		else:
			$PauseMenu/pause_anims.play_backwards("slide_in")
		$PauseMenu.visible = is_paused
		get_tree().paused = is_paused
		await get_tree().create_timer(0.1).timeout
		escape_can_unpause = is_paused

func _ready():
	Globals.crystal_count = 1000
	$AnimationPlayer.play("fade_out")
	match Globals.current_character:
		Globals.Reimu: character_portrait.sprite_frames = reimu_portrait
		Globals.Marisa: character_portrait.sprite_frames = marisa_portrait
	
	Signals.connect("current_power",catch_current_power)
	Signals.connect("next_lvl_update",catch_next_lvl_update)
	Signals.connect("leveling_up",catch_leveling_up)
	Signals.connect("game_over",catch_game_over)
	Signals.connect("increase_max_hp",catch_increase_max_hp)
	Signals.connect("update_crystal",catch_update_crystal)
	Signals.connect("decrease_crystal_count",catch_decrease_crystal_count)
	Signals.connect("not_enough_crystals",catch_not_enough_crystals)
	Signals.connect("taking_damage",catch_taking_damage)
	Signals.connect("increase_mon",catch_increase_mon)
	Signals.connect("current_crystal",catch_current_crystal)
	Signals.connect("total_power",catch_total_power)
	Signals.connect("holding_item",catch_holding_item)
	Signals.connect("show_tooltip",catch_show_tooltip)
	Signals.connect("hide_tooltip",catch_hide_tooltip)

func _process(delta):
	
	if can_skip_anims:
		if Globals.any_input_pressed():
			skip_anims = true
	
	if any_button_label.visible == true:
		if Globals.any_input_pressed():
			goto_main_menu()
	
	$UI/Crystalbar.value = lerp($UI/Crystalbar.value, crystal, delta*2)
	if Input.is_action_just_pressed("escape") and !is_gameover:
		is_paused = !is_paused
	
	$UI/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	
	power = lerp(power,power_update,delta*4)
	powerbar.value = power
	
	if !leveling_up:
		playtime_second += delta
		var playtime_floored = floor(playtime_second)
		if playtime_floored > 59:
			playtime_second = 0.0
			playtime_minute += 1
		
		var playtime_stringed:String
		if playtime_floored < 10:
			playtime_stringed = str(playtime_minute) + ":0" + str(playtime_floored)
		else :
			playtime_stringed = str(playtime_minute) + ":" + str(playtime_floored)
		time_label.text = str(playtime_stringed)
		$UI/Time2.text = str(playtime_stringed)
	
	$UI/Healthbar.value = Globals.player_hp

func _on_portrait_anims_timeout():
	var random_anim:Array = ["head_bob","blink"]
	character_portrait.play(random_anim.pick_random())

func _on_character_portrait_animation_finished():
	if character_portrait.animation == "head_bob":
		character_portrait.frame = 0
	if character_portrait.animation == "smile":
		character_portrait.frame = 3
	if character_portrait.animation == "damage":
		character_portrait.frame = 0
	if character_portrait.animation == "blink":
		character_portrait.frame = 0

func catch_current_power(value):
	var power_percent:float = $UI/Powerbar.value / $UI/Powerbar.max_value
	power_update = value
	if power_update > $UI/Powerbar.value:
		Signals.emit_signal("faith_sfx",power_percent)

func catch_next_lvl_update(value):
	powerbar.max_value = value

func catch_leveling_up(value):
	leveling_up = value
	if leveling_up:
		inven_button_prompts.visible = true
		q_button_prompt.visible = false
		r_button_prompt.visible = false
		$ScreenDim.visible = true
		$AnimationPlayer2.play("dim_screen")
		confetti.emitting = true
		character_portrait.play("smile")
		$PortraitAnims.stop()
		current_lvl += 1
		lvl_label.text = "Lvl " + str(current_lvl)
	else:
		inven_button_prompts.visible = false
		q_button_prompt.visible = false
		r_button_prompt.visible = false
		$ScreenDim.visible = false
		confetti.emitting = false
		character_portrait.play("head_bob")
		$PortraitAnims.start()


func _on_resume_button_down():
	is_paused = false
	$Audio/select.play()

func _on_main_menu_button_up():
	is_paused = false
	goto_main_menu()

func catch_game_over(info:enemy_info):
	game_over_mon = mon
	final_time = time_label.text
	final_crystal = current_crystal
	final_faith = current_faith
	gameover_info = info
	$Gameover.visible = true
	$AnimationPlayer.play("gameover")

func game_over_stats():
	is_gameover = true
	can_skip_anims = true
	
	for iii in time_survived.length():
		time_survived_label.text += time_survived[iii]
		if skip_anims:
			time_survived_label.text = time_survived
			break
		await get_tree().create_timer(0.1).timeout
	
	for iiii in final_time.length():
		final_time_label.text += final_time[iiii]
		if skip_anims:
			final_time_label.text = final_time
			break
		await get_tree().create_timer(0.1).timeout
	
	$AnimationPlayer.play("time_GO_rearrange")
	if skip_anims:
		$AnimationPlayer.speed_scale = 2.0
	
	await $AnimationPlayer.animation_finished
	skip_anims = false
	$AnimationPlayer.speed_scale = 1.0
	
	for i in killed_by.length():
		killed_by_text.text += killed_by[i]
		if skip_anims:
			killed_by_text.text = killed_by
			break
		await get_tree().create_timer(0.1).timeout
	
	
	enemy_sprite.sprite_frames = gameover_info.sprite
	if !skip_anims:
		$AnimationPlayer.play("enemy_sprite_scale_in")
	else:
		enemy_sprite.scale = Vector2(3,3)
	
	if !skip_anims:
		for ii in gameover_info.name.length():
			enemy_name.text += gameover_info.name[ii]
			if skip_anims:
				enemy_name.text = gameover_info.name
				break
			await get_tree().create_timer(0.1).timeout
	else:
		enemy_name.text = gameover_info.name
	
	$AnimationPlayer.play("enemy_GO_rearrange")
	if skip_anims:
		$AnimationPlayer.speed_scale = 2.0
	
	
	await $AnimationPlayer.animation_finished
	skip_anims = false
	$AnimationPlayer.speed_scale = 1.0
	
	for i in pickups_gathered.length():
		pickups_label.text += pickups_gathered[i]
		if skip_anims:
			pickups_label.text = pickups_gathered
			break
		await get_tree().create_timer(0.1).timeout
	
	faith_label.visible = true
	var faith_str:String = str(final_faith)
	var non_skip_faith_label:String = faith_label.text
	for i in faith_str.length():
		faith_label.text += faith_str[i]
		if skip_anims:
			faith_label.text = non_skip_faith_label + faith_str
			break
		await get_tree().create_timer(0.2).timeout
	
	crystals_label.visible = true
	var crystal_str:String = str(final_crystal)
	var non_skip_crystal_label:String = crystals_label.text
	for i in crystal_str.length():
		crystals_label.text += crystal_str[i]
		if skip_anims:
			crystals_label.text = non_skip_crystal_label + crystal_str
			break
		await get_tree().create_timer(0.2).timeout
	
	mon_label.visible = true
	var mon_str:String = str(game_over_mon)
	var non_skip_mon:String = mon_label.text
	for i in mon_str.length():
		mon_label.text += mon_str[i]
		if skip_anims:
			mon_label.text = non_skip_mon + mon_str
			break
		await get_tree().create_timer(0.2).timeout
	
	$AnimationPlayer.play("pickup_GO_rearrange")
	if skip_anims:
		$AnimationPlayer.speed_scale = 2.0
	
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.speed_scale = 1.0
	skip_anims = false
	
	any_button_label.visible = true
	$AnimationPlayer.play("press_to_continue")
	
	can_skip_anims = false

func goto_main_menu():
	get_tree().change_scene_to_file("res://prefabs/levels/main_menu.tscn")

func catch_increase_max_hp(value):
	$UI/Healthbar.max_value = value

func catch_update_crystal(value):
	Signals.emit_signal("crystal_sfx")
	crystal += value
	if crystal >= $UI/Crystalbar.max_value:
		if Globals.crystal_count >= 9.0:
			crystal = $UI/Crystalbar.max_value
		else:
			$UI/shard_count.material.set_shader_parameter("flash_color",Color(1,1,1,1))
			$AnimationPlayer3.play("crystal_number_flash")
			crystal = 0
			Globals.crystal_count += 1.0
			Globals.crystal_count = clamp(Globals.crystal_count,0,9.0)
			$UI/shard_count.frame = Globals.crystal_count
			$UI/Crystalbar.max_value = scale_max_crystal()

func scale_max_crystal():
	var max_crystal:float = 0
	match Globals.crystal_count:
		0.0: max_crystal = 5
		1.0: max_crystal = 11
		2.0: max_crystal = 12
		3.0: max_crystal = 14
		4.0: max_crystal = 16
		5.0: max_crystal = 18
		6.0: max_crystal = 20
		7.0: max_crystal = 24
		8.0: max_crystal = 28
		9.0: max_crystal = 34
	return max_crystal

func catch_decrease_crystal_count():
	$UI/shard_count.frame = Globals.crystal_count
	$UI/shard_count.material.set_shader_parameter("flash_color",Color(1,1,1,1))
	$AnimationPlayer3.play("crystal_number_flash")
	$UI/Crystalbar.max_value = scale_max_crystal()

func catch_not_enough_crystals():
	Signals.emit_signal("not_enough_crystals_sfx")
	$UI/shard_count.material.set_shader_parameter("flash_color",Color(1,0,0,1))
	$AnimationPlayer3.play("number_flash_red_shake")

func _on_crystal_anim_timeout():
	$UI/Crystal.play("default")

func play_damage_modulate():
	$damage_screen.play("modulate")

func catch_taking_damage(value):
	if value:
		Signals.emit_signal("player_damage_sfx")
		$damage_screen.play("fade_in")
		$damage_shake.play("shake")
		character_portrait.play("damage")
	else:
		$damage_screen.play("fade_out")

func catch_increase_mon():
	mon += 1

func catch_current_crystal(value):
	current_crystal = value

func catch_total_power(value):
	current_faith = value

func _on_options_button_down():
	if false:
		$PauseMenu/Options_Menu.visible = true
		$PauseMenu/pause_anims.play("scroll")

func catch_holding_item(value):
	if value:
		q_button_prompt.visible = false
		r_button_prompt.visible = true
	else:
		q_button_prompt.visible = true
		r_button_prompt.visible = false

func catch_show_tooltip():
	q_button_prompt.visible = true

func catch_hide_tooltip():
	q_button_prompt.visible = false
