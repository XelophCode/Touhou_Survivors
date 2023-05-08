extends Control

@export_group("options")
@export_subgroup("video_options")
@export var video_tab : Node2D
@export var resolution_options : OptionButton
@export var window_options : OptionButton
@export var monitor_options : OptionButton
@export var fps_checkbox : CheckBox
@export var revert_label : Label
@export var revert_timer : Timer
@export var keep_video_settings : Node2D
@export var video_apply_button : Button
@export_subgroup("audio_options")
@export var audio_tab : Node2D
@export var master_audio_slider : HSlider
@export var music_audio_slider : HSlider
@export var sfx_audio_slider : HSlider
@export var item_audio_slider : HSlider
@export_subgroup("input_options")
@export var input_tab : Node2D

var video_settings:Array = [Vector2(426,240),0,0]
var video_settings_new:Array = [Vector2(426,240),0,0]
#var screen_center:Vector2
var video_settings_indices:Array = [0,0,0]

func _ready():
	Signals.connect("open_options_menu",catch_open_options_menu)
	Signals.connect("close_options_menu",catch_close_options_menu)
	monitor_options.clear()
	for i in DisplayServer.get_screen_count():
		monitor_options.add_item("Monitor " + str(i),i)
	
#	var file = FileAccess.open(Globals.settings_file_path, FileAccess.READ)
	if FileAccess.file_exists(Appdata.settings_file_path):
		var loaded_settings = Appdata.load_file(Appdata.SETTINGS)
		
		video_settings = [loaded_settings.RESOLUTION,loaded_settings.WINDOW_MODE,loaded_settings.MONITOR]
		video_settings_new = [loaded_settings.RESOLUTION,loaded_settings.WINDOW_MODE,loaded_settings.MONITOR]
		
		match loaded_settings.RESOLUTION.x:
			426.0: resolution_options.selected = 0
			640.0: resolution_options.selected = 1
			854.0: resolution_options.selected = 2
			1280.0: resolution_options.selected = 3
			1920.0: resolution_options.selected = 4
			2560.0: resolution_options.selected = 5
			3840.0: resolution_options.selected = 6
		
		window_options.selected = loaded_settings.WINDOW_MODE
		if DisplayServer.get_screen_count() - 1 < loaded_settings.MONITOR:
			monitor_options.selected = 0
		else:
			monitor_options.selected = loaded_settings.MONITOR
		
		fps_checkbox.button_pressed = loaded_settings.SHOW_FPS
		
		video_settings_indices[0] = resolution_options.selected
		video_settings_indices[1] = window_options.selected
		video_settings_indices[2] = monitor_options.selected
		
		master_audio_slider.value = loaded_settings.MASTER_AUDIO
		music_audio_slider.value = loaded_settings.MUSIC_AUDIO
		sfx_audio_slider.value = loaded_settings.SFX_AUDIO
		item_audio_slider.value = loaded_settings.ITEM_AUDIO

func _process(_delta):
	if visible:
		if Input.is_action_just_pressed("escape"):
			catch_close_options_menu()
		
		if video_settings != video_settings_new:
			video_apply_button.visible = true
		else:
			video_apply_button.visible = false

func _on_video_b_button_down():
	video_tab.visible = true
	audio_tab.visible = false
	input_tab.visible = false


func _on_audio_b_button_down():
	reset_video_options()
	video_tab.visible = false
	audio_tab.visible = true
	input_tab.visible = false


func _on_input_b_button_down():
	reset_video_options()
	video_tab.visible = false
	audio_tab.visible = false
	input_tab.visible = true


func _on_resolution_item_selected(index):
	
	match index:
		0: video_settings_new[0] = Vector2(426,240)
		1: video_settings_new[0] = Vector2(640,360)
		2: video_settings_new[0] = Vector2(854,480)
		3: video_settings_new[0] = Vector2(1280,720)
		4: video_settings_new[0] = Vector2(1920,1080)
		5: video_settings_new[0] = Vector2(2560,1440)
		6: video_settings_new[0] = Vector2(3840,2160)
	


func _on_video_apply_button_down():
	
	DisplayServer.window_set_size(video_settings_new[0])
	
	DisplayServer.window_set_position(Vector2i(Globals.screen_center.x - video_settings_new[0].x/2,Globals.screen_center.y - video_settings_new[0].y/2))
	match video_settings_new[1]:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	DisplayServer.window_set_current_screen(video_settings_new[2])
	
	keep_video_settings.visible = true
	revert_timer.start()


func _on_window_item_selected(index):
	video_settings_new[1] = index

func _on_monitor_item_selected(index):
	video_settings_new[2] = index

#KEEP VIDEO SETTINGS
func _on_yes_button_down():
	video_settings = video_settings_new.duplicate()
	video_settings_indices[0] = resolution_options.selected
	video_settings_indices[1] = window_options.selected
	video_settings_indices[2] = monitor_options.selected
	keep_video_settings.visible = false
	
	Appdata.save_file(Appdata.SETTINGS,"RESOLUTION",video_settings[0])
	Appdata.save_file(Appdata.SETTINGS,"WINDOW_MODE",video_settings[1])
	Appdata.save_file(Appdata.SETTINGS,"MONITOR",video_settings[2])

func revert_video_changes():
	DisplayServer.window_set_size(video_settings[0])
	
	DisplayServer.window_set_position(Vector2i(Globals.screen_center.x - video_settings[0].x/2,Globals.screen_center.y - video_settings[0].y/2))
	match video_settings[1]:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	DisplayServer.window_set_current_screen(video_settings[2])
	reset_video_options()
	

func reset_video_options():
	resolution_options.selected = video_settings_indices[0]
	window_options.selected = video_settings_indices[1]
	monitor_options.selected = video_settings_indices[2]
	
	video_settings_new = video_settings.duplicate()
	

func _on_timer_timeout():
	keep_video_settings.visible = false
	revert_video_changes()

func _on_no_button_down():
	revert_timer.stop()
	revert_video_changes()
	keep_video_settings.visible = false


func _on_close_button_down():
	catch_close_options_menu()

func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(1,value)

func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(2,value)

func _on_item_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(3,value)

func catch_open_options_menu():
	visible = true
	$AnimationPlayer.play("scroll_anim")

func catch_close_options_menu():
	$AnimationPlayer.play_backwards("scroll_anim")
	reset_video_options()
	await get_tree().create_timer(0.5).timeout
	visible = false
	Signals.emit_signal("options_menu_closed")

func _on_master_drag_ended(_value_changed):
	audio_save(0,"MASTER_AUDIO")

func _on_music_drag_ended(_value_changed):
	audio_save(1,"MUSIC_AUDIO")

func _on_sfx_drag_ended(_value_changed):
	audio_save(2,"SFX AUDIO")

func _on_item_sfx_drag_ended(_value_changed):
	audio_save(3,"ITEM_AUDIO")

func audio_save(audio_bus:int, dict_key:String):
	Appdata.save_file(Appdata.SETTINGS,dict_key,AudioServer.get_bus_volume_db(audio_bus))

func _on_fps_toggled(button_pressed):
	Signals.emit_signal("show_fps",button_pressed)
	Appdata.save_file(Appdata.SETTINGS,"SHOW_FPS",button_pressed)
