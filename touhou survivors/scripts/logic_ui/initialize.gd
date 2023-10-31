extends Node2D

var screen_center : Vector2


func _ready():
	print(str(Steam.steamInit()))
	screen_center = DisplayServer.window_get_position()
	screen_center.x += 426.0/2
	screen_center.y += 240.0/2
	Globals.screen_center = screen_center
	load_appdata()
	DisplayServer.window_set_title("Touhou: Gensokyo Survivors")
	get_tree().change_scene_to_file("res://prefabs/levels/main_menu.tscn")
	


func load_appdata():
	if !FileAccess.file_exists(Appdata.settings_file_path):
		Appdata.file_write_new(Appdata.SETTINGS)
	if !FileAccess.file_exists(Appdata.save_file_path):
		Appdata.file_write_new(Appdata.SAVE)
	
	
	if FileAccess.file_exists(Appdata.settings_file_path):
		var loaded_settings = Appdata.load_file(Appdata.SETTINGS)
		Appdata.check_file_version(Appdata.SETTINGS)
		load_settings(loaded_settings)
	
	if FileAccess.file_exists(Appdata.save_file_path):
		Appdata.check_file_version(Appdata.SAVE)



func load_settings(loaded_settings):
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
	
	
