extends Node2D

@export var main_menu_bg : Node
@export var main_menu_logo : Node
@export var main_animation_player : Node
@export var button_anims : Node
@export var version_label : Label

@export_group("achievements")
@export var time_survived:Label
@export var lifetime_mon:Label
@export var deaths:Label
@export var faith:Label
@export var crystals:Label
@export var items:Label
@export var spellcards:Label
@export var spellcard_all:Label
@export var lily_white:Label
@export var daiyousei:Label
@export var characters:Label

@export_group("tutorial_videos")
@export var pg_1_1:VideoStreamPlayer
@export var pg_1_2:VideoStreamPlayer
@export var pg_1_3:VideoStreamPlayer
@export var pg_2_1:VideoStreamPlayer
@export var pg_2_2:VideoStreamPlayer
@export var pg_3_1:VideoStreamPlayer
@export var pg_3_2:VideoStreamPlayer

var reset_audio_DB:float
var loaded_save
var current_tut_page:int = 1
var doing_panning_anim:bool = true
var doing_press_start_anim:bool = false

func _ready():
	Signals.connect("options_menu_closed",catch_options_menu_closed)
	
	var tween = create_tween()
	tween.tween_property($Audio/music,"volume_db",10.0,3)
	$FullscreenPink.visible = false
	$FullscreenPink.material.set_shader_parameter("dissolve_value",0.0)
	
	loaded_save = Appdata.load_file(Appdata.SAVE)
	
	var all_spell_text:String
	if loaded_save.ALL_SPELLCARDS == 1:
		all_spell_text = "1"
	else:
		all_spell_text = "0"
	
	time_survived.text = loaded_save.BEST_TIME_STRING
	lifetime_mon.text = str(loaded_save.MON_LIFETIME)
	deaths.text = str(loaded_save.DEATHS)
	faith.text = str(loaded_save.FAITH_LIFETIME)
	crystals.text = str(loaded_save.CRYSTALS_LIFETIME)
	items.text = str(loaded_save.ITEMS_USED) + "/27"
	spellcards.text = str(loaded_save.SPELLCARDS_USED) + "/5"
	spellcard_all.text = all_spell_text + "/1"
	lily_white.text = str(loaded_save.LILY_WHITE) + "/1"
	daiyousei.text = str(loaded_save.DAIYOUSEI) + "/1"
	characters.text = str(8 - loaded_save.LOCKED_CHARACTERS.size()) + "/8"
	
	version_label.text = "ver " + Globals.app_version
	
	check_for_unlocked_achievements()

func _process(_delta):
	
	if doing_panning_anim and !doing_press_start_anim:
		if Globals.any_input_just_pressed():
			main_animation_player.stop()
			main_menu_bg.position.y = 480
			$FullscreenWhite.visible = false
			main_menu_logo.position.y = -360
			main_menu_logo.material.set_shader_parameter("dissolve_value",1.0)
			main_menu_logo.material.set_shader_parameter("flash_modifier",0.0)
			main_menu_logo.material.set_shader_parameter("opacity",1.0)
			show_press_start()
	elif !doing_panning_anim and doing_press_start_anim:
		if Globals.any_input_just_pressed():
			doing_press_start_anim = false
			$Buttons.visible = true
			$PressStart.visible = false
			$Audio/select.play()

func fade_in_logo():
	main_animation_player.play("logo_fade_in")

func show_press_start():
	doing_panning_anim = false
	doing_press_start_anim = true
	$PressStart.visible = true
	main_animation_player.play("press_start")

func _on_start_button_down():
	$block_inputs.visible = true
	$Audio/select.play()
	button_anims.play("start")
	await get_tree().create_timer(0.3).timeout
	$SakuraFade.play("Sakura")
	$FullscreenPink.visible = true
	
	for i in $Audio.get_child_count():
		if i == 3:
			break
		var audio_comp = $Audio.get_child(i)
		audio_comp.volume_db = 0
		var tween_audio = create_tween()
		tween_audio.tween_property(audio_comp,"volume_db",-60,2.0)

func go_to_character_select():
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://prefabs/levels/character_select.tscn")


func _on_quit_button_down():
	$block_inputs.visible = true
	$Audio/select.play()
	button_anims.play("quit")
	await get_tree().create_timer(0.3).timeout
	$BlackFade.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_manual_button_up():
	current_tut_page = 1
	$tutorial_overlay.visible = true
	play_videos()

func _on_options_button_down():
	$options_overlay.visible = true
	Signals.emit_signal("open_options_menu")

func catch_options_menu_closed():
	$options_overlay.visible = false

func _on_credits_button_down():
	$credits.visible = true
	$Buttons/manual.visible = false
	$Buttons/credits.visible = false

func _on_close_button_down():
	$credits.visible = false
	$Buttons/manual.visible = true
	$Buttons/credits.visible = true

func _on_achievements_button_down():
	$Achievements.visible = true

func _on_closeachievements_button_up():
	$Achievements.visible = false


func _on_close_tutorial_button_up():
	stop_videos()
	$tutorial_overlay.visible = false
	$tutorial_overlay/Tutorial/page_1.visible = true
	$tutorial_overlay/Tutorial/page_2.visible = false
	$tutorial_overlay/Tutorial/page_3.visible = false
	$tutorial_overlay/Tutorial/page_4.visible = false
	$tutorial_overlay/Tutorial/arrow_left.visible = false
	$tutorial_overlay/Tutorial/arrow_right.visible = true

func change_tut_page():
	$tutorial_overlay/Tutorial/page_1.visible = false
	$tutorial_overlay/Tutorial/page_2.visible = false
	$tutorial_overlay/Tutorial/page_3.visible = false
	$tutorial_overlay/Tutorial/page_4.visible = false
	
	match current_tut_page:
		1: $tutorial_overlay/Tutorial/page_1.visible = true; $tutorial_overlay/Tutorial/arrow_left.visible = false
		2: $tutorial_overlay/Tutorial/page_2.visible = true; $tutorial_overlay/Tutorial/arrow_left.visible = true
		3: $tutorial_overlay/Tutorial/page_3.visible = true; $tutorial_overlay/Tutorial/arrow_right.visible = true
		4: $tutorial_overlay/Tutorial/page_4.visible = true; $tutorial_overlay/Tutorial/arrow_right.visible = false

func play_videos():
	stop_videos()
	
	match current_tut_page:
		1: pg_1_1.play();pg_1_2.play();pg_1_3.play()
		2: pg_2_1.play();pg_2_2.play()
		3: pg_3_1.play();pg_3_2.play()
		4: pass

func stop_videos():
	pg_1_1.stop()
	pg_1_2.stop()
	pg_1_3.stop()
	pg_2_1.stop()
	pg_2_2.stop()
	pg_3_1.stop()
	pg_3_2.stop()

func _on_b_arrow_left_button_up():
	current_tut_page -= 1
	change_tut_page()
	play_videos()

func _on_b_arrow_right_button_up():
	current_tut_page += 1
	change_tut_page()
	play_videos()

func check_for_unlocked_achievements():
	var loaded_save = Appdata.load_file(Appdata.SAVE)
	
	if loaded_save.DEATHS >= 100:
		Steam.setAchievement("ach_100_deaths")
	if loaded_save.MON_LIFETIME >= 100000:
		Steam.setAchievement("ach_100000_mon")
	if loaded_save.FAITH_LIFETIME >= 10000:
		Steam.setAchievement("ach_10000_faith")
	if loaded_save.CRYSTALS_LIFETIME >= 10000:
		Steam.setAchievement("ach_10000_crystals")
	
	Steam.storeStats()
