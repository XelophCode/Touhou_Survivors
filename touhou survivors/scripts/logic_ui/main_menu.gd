extends Node2D

@export var main_menu_bg : Node
@export var main_menu_logo : Node
@export var main_animation_player : Node
@export var button_anims : Node
@export var version_label : Label
@export var hidden_button : Button
@export var locked_button : Button
@export var tutorial_button_right : Button
@export var close_tutorial_button : Button
@export var tutorial_button : Button
@export var tutorial_button_left : Button
@export var options_button : Button
@export var achievements_close_button : Button
@export var achievements_button : Button
@export var credits_close_button : Button
@export var credits_button : Button

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
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Signals.connect("options_menu_closed",catch_options_menu_closed)
	
	var tween = create_tween()
	tween.tween_property($Audio/music,"volume_db",10.0,3)
	$FullscreenPink.visible = false
	$FullscreenPink.material.set_shader_parameter("dissolve_value",0.0)
	
	loaded_save = Appdata.load_file(Appdata.SAVE)
	var loaded_settings = Appdata.load_file(Appdata.SETTINGS)
	
	$CanvasLayer/FPS.visible = loaded_settings.SHOW_FPS
	DisplayServer.window_set_size(loaded_settings.RESOLUTION)
	DisplayServer.window_set_position(Vector2i(Globals.screen_center.x - loaded_settings.RESOLUTION.x/2,Globals.screen_center.y - loaded_settings.RESOLUTION.y/2))
	match loaded_settings.WINDOW_MODE:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	
	if DisplayServer.get_screen_count() - 1 < loaded_settings.MONITOR:
		DisplayServer.window_set_current_screen(0)
	else:
		DisplayServer.window_set_current_screen(loaded_settings.MONITOR)
	
	AudioServer.set_bus_volume_db(0,loaded_settings.MASTER_AUDIO)
	AudioServer.set_bus_volume_db(1,loaded_settings.MUSIC_AUDIO)
	AudioServer.set_bus_volume_db(2,loaded_settings.SFX_AUDIO)
	AudioServer.set_bus_volume_db(3,loaded_settings.ITEM_AUDIO)
	
	
	
	Globals.button_prompts = loaded_settings.BUTTON_PROMPTS
	
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
	
	if !loaded_settings.MANUAL_CHECKED:
		$manual_blink.play("blink")
	
	version_label.text = "ver " + Globals.app_version
	
	check_for_unlocked_achievements()

func _input(event):
	if event is InputEventMouseMotion:
		if !$tutorial_overlay.visible and !$options_overlay.visible and !$credits.visible and !$Achievements.visible:
			hidden_button.grab_focus()

func _process(_delta):
	$CanvasLayer/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	
	if Input.is_action_just_pressed("left_mouse_button"):
		if !$tutorial_overlay.visible and !$options_overlay.visible and !$credits.visible and !$Achievements.visible:
			hidden_button.grab_focus()
		
	
	
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
			hidden_button.grab_focus()

func fade_in_logo():
	main_animation_player.play("logo_fade_in")

func show_press_start():
	doing_panning_anim = false
	doing_press_start_anim = true
	$PressStart.visible = true
	main_animation_player.play("press_start")

func _on_start_button_down():
	locked_button.grab_focus()
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
	SceneManager.change_scene(SceneManager.character_select,self)


func _on_quit_button_down():
	locked_button.grab_focus()
	$block_inputs.visible = true
	$Audio/select.play()
	button_anims.play("quit")
	await get_tree().create_timer(0.3).timeout
	$BlackFade.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_manual_button_up():
	tutorial_button_right.grab_focus()
	close_tutorial_button.focus_neighbor_left = tutorial_button_right.get_path(); close_tutorial_button.focus_neighbor_right = tutorial_button_right.get_path(); close_tutorial_button.focus_neighbor_bottom = tutorial_button_right.get_path(); tutorial_button_right.focus_neighbor_left = tutorial_button_right.get_path()
	current_tut_page = 1
	$tutorial_overlay.visible = true
	play_videos()
	Appdata.save_file(Appdata.SETTINGS,"MANUAL_CHECKED",true)
	$manual_blink.stop()

func _on_options_button_down():
	$options_overlay.visible = true
	Signals.emit_signal("open_options_menu")
	Globals.former_focused_button = options_button

func catch_options_menu_closed():
	$options_overlay.visible = false

func _on_credits_button_down():
	credits_close_button.grab_focus()
	$credits.visible = true
	$Buttons/manual.visible = false
	$Buttons/credits.visible = false

func _on_close_button_down():
	credits_button.grab_focus()
	$credits.visible = false
	$Buttons/manual.visible = true
	$Buttons/credits.visible = true

func _on_achievements_button_down():
	$Achievements.visible = true
	achievements_close_button.grab_focus()

func _on_closeachievements_button_up():
	$Achievements.visible = false
	achievements_button.grab_focus()


func _on_close_tutorial_button_up():
	tutorial_button.grab_focus()
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
		1: $tutorial_overlay/Tutorial/page_1.visible = true; $tutorial_overlay/Tutorial/arrow_left.visible = false; tutorial_button_right.grab_focus(); close_tutorial_button.focus_neighbor_left = tutorial_button_right.get_path(); close_tutorial_button.focus_neighbor_right = tutorial_button_right.get_path(); close_tutorial_button.focus_neighbor_bottom = tutorial_button_right.get_path(); tutorial_button_right.focus_neighbor_left = tutorial_button_right.get_path()
		2: $tutorial_overlay/Tutorial/page_2.visible = true; $tutorial_overlay/Tutorial/arrow_left.visible = true; tutorial_button_right.focus_neighbor_left = tutorial_button_left.get_path()
		3: $tutorial_overlay/Tutorial/page_3.visible = true; $tutorial_overlay/Tutorial/arrow_right.visible = true; tutorial_button_left.focus_neighbor_right = tutorial_button_right.get_path()
		4: $tutorial_overlay/Tutorial/page_4.visible = true; $tutorial_overlay/Tutorial/arrow_right.visible = false; tutorial_button_left.grab_focus(); close_tutorial_button.focus_neighbor_right = tutorial_button_left.get_path(); close_tutorial_button.focus_neighbor_left = tutorial_button_left.get_path(); close_tutorial_button.focus_neighbor_bottom = tutorial_button_left.get_path(); tutorial_button_left.focus_neighbor_right = tutorial_button_left.get_path()

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
	if loaded_save.ITEMS_USED >= 27:
		Steam.setAchievement("ach_all_items")
	if loaded_save.SPELLCARDS_USED >= 5:
		Steam.setAchievement("ach_all_spellcards")
	if loaded_save.ALL_SPELLCARDS == 1:
		Steam.setAchievement("ach_simul_spellcards")
	if loaded_save.LILY_WHITE == 1:
		Steam.setAchievement("ach_lily_white")
	if loaded_save.DAIYOUSEI == 1:
		Steam.setAchievement("ach_daiyousei")
	if loaded_save.LOCKED_CHARACTERS.size() == 0:
		Steam.setAchievement("ach_all_characters")
	
	Steam.storeStats()
