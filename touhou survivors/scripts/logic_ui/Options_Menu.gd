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
@export var toggle_focus_checkbox : CheckBox
@export var move_up_0 : Button
@export var move_up_1 : Button
@export var move_down_0 : Button
@export var move_down_1 : Button
@export var move_left_0 : Button
@export var move_left_1 : Button
@export var move_right_0 : Button
@export var move_right_1 : Button
@export var interactfocus_0 : Button
@export var interactfocus_1 : Button
@export var cancel_0 : Button
@export var cancel_1 : Button
@export var reset_keybinds : Button
@export var revert_overlay : Node2D
@export var revert_key_countdown : Label
@export var revert_key_timer : Timer

var video_settings:Array = [Vector2(426,240),0,0]
var video_settings_new:Array = [Vector2(426,240),0,0]

var video_settings_indices:Array = [0,0,0]

var rebinding_key:bool = false
var last_action_event:Array
var action_target:String
var keybind_button_target:Button

var default_up_0:InputEventKey = InputMap.action_get_events("move_up")[0]
var default_up_1:InputEventKey = InputMap.action_get_events("move_up")[1]

var last_key_text:String
var action_event_target:int

var move_up_binds:Array
var move_down_binds:Array
var move_left_binds:Array
var move_right_binds:Array

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
		
		toggle_focus_checkbox.button_pressed = loaded_settings.TOGGLE_FOCUS
		
		move_up_0.text = loaded_settings.MOVE_UP[1][0]
		move_up_1.text = loaded_settings.MOVE_UP[1][1]
		move_down_0.text = loaded_settings.MOVE_DOWN[1][0]
		move_down_1.text = loaded_settings.MOVE_DOWN[1][1]
		move_left_0.text = loaded_settings.MOVE_LEFT[1][0]
		move_left_1.text = loaded_settings.MOVE_LEFT[1][1]
		move_right_0.text = loaded_settings.MOVE_RIGHT[1][0]
		move_right_1.text = loaded_settings.MOVE_RIGHT[1][1]
		interactfocus_0.text = loaded_settings.INTERACT[1][0]
		interactfocus_1.text = loaded_settings.INTERACT[1][1]
		cancel_0.text = loaded_settings.CANCEL[1][0]
		cancel_1.text = loaded_settings.CANCEL[1][1]
		
		load_input(loaded_settings.MOVE_UP,"move_up")
		load_input(loaded_settings.MOVE_DOWN,"move_down")
		load_input(loaded_settings.MOVE_LEFT,"move_left")
		load_input(loaded_settings.MOVE_RIGHT,"move_right")
		load_interact_input(loaded_settings.INTERACT,"interact")
		load_input(loaded_settings.CANCEL,"cancel")
		

func load_input(loaded_input:Array,input_action:String):
	var input_0 = InputEventKey.new()
	var input_1 = InputEventKey.new()
	input_0.physical_keycode = loaded_input[0][0]
	input_1.physical_keycode = loaded_input[0][1]
	var input_array:Array = [input_0,input_1]
	InputMap.action_erase_events(input_action)
	bind_key(input_array,input_action)

func load_interact_input(loaded_input:Array,_input_action:String):
	InputMap.action_erase_events("interact")
	var input_key = InputEventKey.new()
	input_key.physical_keycode = loaded_input[0][0]
	var input_rmb = InputEventMouseButton.new()
	input_rmb.button_index = MOUSE_BUTTON_RIGHT
	InputMap.action_add_event("interact",input_key)
	InputMap.action_add_event("interact",input_rmb)
	
#	var input_0 = InputEventKey.new()
#	input_0.physical_keycode = loaded_input[0][0]
#	var input_array:Array = [input_0]
#	InputMap.action_erase_event(input_action,InputMap.action_get_events(input_action)[0])
#	bind_key(input_array,input_action)

func _process(_delta):
	if visible:
		if Input.is_action_just_pressed("escape"):
			catch_close_options_menu()
		
		if video_settings != video_settings_new:
			video_apply_button.visible = true
		else:
			video_apply_button.visible = false
		
		revert_key_countdown.text = str(ceil(revert_key_timer.time_left))

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

func _on_toggle_focus_toggled(button_pressed):
	Signals.toggle_focus.emit(button_pressed)
	Appdata.save_file(Appdata.SETTINGS,"TOGGLE_FOCUS",button_pressed)


func _on_move_up_button_up():
	keybind_button_target = move_up_0
	key_rebind("move_up",0)
func _on_move_up_2_button_up():
	keybind_button_target = move_up_1
	key_rebind("move_up",1)
func _on_move_down_button_up():
	keybind_button_target = move_down_0
	key_rebind("move_down",0)
func _on_move_down_2_button_up():
	keybind_button_target = move_down_1
	key_rebind("move_down",1)
func _on_move_left_button_up():
	keybind_button_target = move_left_0
	key_rebind("move_left",0)
func _on_move_left_2_button_up():
	keybind_button_target = move_left_1
	key_rebind("move_left",1)
func _on_move_right_button_up():
	keybind_button_target = move_right_0
	key_rebind("move_right",0)
func _on_move_right_2_button_up():
	keybind_button_target = move_right_1
	key_rebind("move_right",1)
func _on_interactfocus_button_up():
	keybind_button_target = interactfocus_0
	key_rebind("interact",0)
func _on_interactfocus_2_button_up():
	keybind_button_target = interactfocus_1
	key_rebind("interact",1)
func _on_cancel_button_up():
	keybind_button_target = cancel_0
	key_rebind("cancel",0)
func _on_cancel_2_button_up():
	keybind_button_target = cancel_1
	key_rebind("cancel",1)

func key_rebind(action_name:String,event_id:int):
	last_action_event = InputMap.action_get_events(action_name)
	last_key_text = keybind_button_target.text
	keybind_button_target.text = "PRESS KEY"
	action_event_target = event_id
	InputMap.action_erase_events(action_name)
	action_target = action_name
	revert_key_timer.start()
	revert_overlay.visible = true
	rebinding_key = true

func _unhandled_key_input(event):
	if rebinding_key:
		last_action_event[action_event_target] = event
		bind_key(last_action_event,action_target)
		keybind_button_target.text = str(OS.get_keycode_string(last_action_event[action_event_target].physical_keycode))
		save_key_bind(action_target)
		stop_key_rebind()

#func _input(event):
#	if rebinding_key:
#		if (event is InputEventKey) or (Input.is_action_just_pressed("right_mouse_button")):
#			print(str(event))
#			last_action_event[action_event_target] = event
#			bind_key(last_action_event,action_target)
#			if Input.is_action_just_pressed("right_mouse_button"):
#
#				keybind_button_target.text = "RMB"
#			else:
#				keybind_button_target.text = str(OS.get_keycode_string(last_action_event[action_event_target].physical_keycode))
#			save_key_bind(action_target)
#			stop_key_rebind()

func bind_key(action_event,target):
	for i in action_event:
		InputMap.action_add_event(target,i)

func save_key_bind(action_target_local):
	match action_target_local:
		"move_up": Appdata.save_file(Appdata.SETTINGS,"MOVE_UP",[[last_action_event[0].physical_keycode,last_action_event[1].physical_keycode],[move_up_0.text,move_up_1.text]])
		"move_down": Appdata.save_file(Appdata.SETTINGS,"MOVE_DOWN",[[last_action_event[0].physical_keycode,last_action_event[1].physical_keycode],[move_down_0.text,move_down_1.text]])
		"move_left": Appdata.save_file(Appdata.SETTINGS,"MOVE_LEFT",[[last_action_event[0].physical_keycode,last_action_event[1].physical_keycode],[move_left_0.text,move_left_1.text]])
		"move_right": Appdata.save_file(Appdata.SETTINGS,"MOVE_RIGHT",[[last_action_event[0].physical_keycode,last_action_event[1].physical_keycode],[move_right_0.text,move_right_1.text]])
		"interact": Appdata.save_file(Appdata.SETTINGS,"INTERACT",[[last_action_event[0].physical_keycode],[interactfocus_0.text,interactfocus_1.text]])
		"cancel": Appdata.save_file(Appdata.SETTINGS,"CANCEL",[[last_action_event[0].physical_keycode,last_action_event[1].physical_keycode],[cancel_0.text,cancel_1.text]])

func stop_key_rebind():
	revert_key_timer.stop()
	revert_overlay.visible = false
	rebinding_key = false

func _on_revert_key_timeout():
	revert_rebind()

func revert_rebind():
	for i in last_action_event:
		InputMap.action_add_event(action_target,i)
	keybind_button_target.text = last_key_text
	stop_key_rebind()

func _on_cancel_keybind_button_down():
	revert_rebind()


func _on_reset_keybinds_button_up():
	bind_reset_keys([87,4194320],"move_up")
	bind_reset_keys([83,4194322],"move_down")
	bind_reset_keys([65,4194319],"move_left")
	bind_reset_keys([68,4194321],"move_right")
	
	InputMap.action_erase_events("interact")
	var input_key = InputEventKey.new()
	input_key.physical_keycode = 4194325
	var input_rmb = InputEventMouseButton.new()
	input_rmb.button_index = MOUSE_BUTTON_RIGHT
	InputMap.action_add_event("interact",input_key)
	InputMap.action_add_event("interact",input_rmb)
	interactfocus_0.text = "Shift"
	interactfocus_1.text = "RMB"
	
	bind_reset_keys([4194306,88],"cancel")
	
	
	Appdata.save_file(Appdata.SETTINGS,"MOVE_UP",[[87,4194320],[move_up_0.text,move_up_1.text]])
	Appdata.save_file(Appdata.SETTINGS,"MOVE_DOWN",[[83,4194322],[move_down_0.text,move_down_1.text]])
	Appdata.save_file(Appdata.SETTINGS,"MOVE_LEFT",[[65,4194319],[move_left_0.text,move_left_1.text]])
	Appdata.save_file(Appdata.SETTINGS,"MOVE_RIGHT",[[68,4194321],[move_right_0.text,move_right_1.text]])
	Appdata.save_file(Appdata.SETTINGS,"INTERACT",[[4194325],[interactfocus_0.text,interactfocus_1.text]])
	Appdata.save_file(Appdata.SETTINGS,"CANCEL",[[4194306,88],[cancel_0.text,cancel_1.text]])

func bind_reset_keys(keycodes:Array,input_action:String):
	var input_0 = InputEventKey.new()
	var input_1 = InputEventKey.new()
	input_0.physical_keycode = keycodes[0]
	input_1.physical_keycode = keycodes[1]
	var input_array:Array = [input_0,input_1]
	InputMap.action_erase_events(input_action)
	bind_key(input_array,input_action)
	
	match input_action:
		"move_up": move_up_0.text = "W"; move_up_1.text = "Up"
		"move_down": move_down_0.text = "S"; move_down_1.text = "Down"
		"move_left": move_left_0.text = "A"; move_left_1.text = "Left"
		"move_right": move_right_0.text = "D"; move_right_1.text = "Right"
		"cancel": cancel_0.text = "Tab"; cancel_1.text = "X"
		
