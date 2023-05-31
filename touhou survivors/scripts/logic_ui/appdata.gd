extends Node

enum {SETTINGS,SAVE}

const save_file_path : String = "user://save.dat"
const settings_file_path : String = "user://settings.dat"

var settings:Dictionary
var save:Dictionary


func save_file(file_name:int,key:String,value):
	match file_name:
		SETTINGS:
			settings[key] = value
			write_to_file(settings_file_path,settings)
		SAVE:
			save[key] = value
			write_to_file(save_file_path,save)

func write_to_file(file_path:String,value):
	var file = FileAccess.open(file_path,FileAccess.WRITE)
	file.store_var(value)
	file.close()

func load_file(file_name:int):
	var data
	match file_name:
		SETTINGS:
			data = read_from_file(settings_file_path)
			settings = data
		SAVE:
			data = read_from_file(save_file_path)
			save = data
		_: return
	
	return data

func read_from_file(file_path:String):
	var file = FileAccess.open(file_path,FileAccess.READ)
	var data = file.get_var()
	file.close()
	return data

func file_write_new(file_name:int):
	
	match file_name:
		SETTINGS:
			settings = {
				"VERSION" = Globals.app_version,
				"RESOLUTION" = Vector2(1280,720),
				"WINDOW_MODE" = 0,
				"MONITOR" = 0,
				"MASTER_AUDIO" = -10.0,
				"MUSIC_AUDIO" = -10.0,
				"SFX_AUDIO" = -5.0,
				"ITEM_AUDIO" = -5.0,
				"SHOW_FPS" = false,
				"TOGGLE_FOCUS" = false,
				"MOVE_UP" = [[InputMap.action_get_events("move_up")[0].physical_keycode,InputMap.action_get_events("move_up")[1].physical_keycode],["W","Up"]],
				"MOVE_DOWN" = [[InputMap.action_get_events("move_down")[0].physical_keycode,InputMap.action_get_events("move_down")[1].physical_keycode],["S","Down"]],
				"MOVE_LEFT" = [[InputMap.action_get_events("move_left")[0].physical_keycode,InputMap.action_get_events("move_left")[1].physical_keycode],["A","Left"]],
				"MOVE_RIGHT" = [[InputMap.action_get_events("move_right")[0].physical_keycode,InputMap.action_get_events("move_right")[1].physical_keycode],["D","Right"]],
				"INTERACT" = [[InputMap.action_get_events("interact")[0].physical_keycode],["Shift","RMB"]],
				"CANCEL" = [[InputMap.action_get_events("cancel")[0].physical_keycode,InputMap.action_get_events("cancel")[1].physical_keycode],["Tab","X"]]
			}
			write_to_file(settings_file_path,settings)
		SAVE:
			save = {
				"VERSION" = Globals.app_version,
				"LOCKED_CHARACTERS" = ["Remilia","Aya","Suika","Reisen","Youmu","Cirno"],
				"MON" = 0,
				"BEST_TIME_NUM" = 0,
				"BEST_TIME_STRING" = "0:00",
				"DEATHS" = 0,
				"MON_LIFETIME" = 0,
				"FAITH_LIFETIME" = 0,
				"CRYSTALS_LIFETIME" = 0,
				"ITEM_NAMES" = [],
				"ITEMS_USED" = 0,
				"SPELLCARD_NAMES" = [],
				"SPELLCARDS_USED" = 0,
				"ALL_SPELLCARDS" = 0,
				"LILY_WHITE" = 0,
				"DAIYOUSEI" = 0
			}
			write_to_file(save_file_path,save)

func check_file_version(file_name:int):
	match file_name:
		SETTINGS:
			var loaded_settings = load_file(SETTINGS)
			if !loaded_settings.has("VERSION"):
				print("UPDATING SETTINGS FILE")
				file_version_update(file_name)
			elif loaded_settings.VERSION != Globals.app_version:
				print("UPDATING SETTINGS FILE")
				file_version_update(file_name)
			else:
				print("SETTINGS FILE VER " + str(loaded_settings.VERSION))
		SAVE:
			var loaded_save = load_file(SAVE)
			if !loaded_save.has("VERSION"):
				print("UPDATING SAVE FILE")
				file_version_update(file_name)
			elif loaded_save.VERSION != Globals.app_version:
				print("UPDATING SAVE FILE")
				file_version_update(file_name)
			else:
				print("SAVE FILE VER " + str(loaded_save.VERSION))

func file_version_update(file_name:int):
	match file_name:
		SETTINGS:
			var loaded_settings = load_file(SETTINGS)
			#MAKE SURE GLOBAL VERSION IS CORRECT!
			loaded_settings["VERSION"] = Globals.app_version
			#NEW FILE VALUES GO HERE
			loaded_settings["TOGGLE_FOCUS"] = false
			loaded_settings["MOVE_UP"] = [[InputMap.action_get_events("move_up")[0].physical_keycode,InputMap.action_get_events("move_up")[1].physical_keycode],["W","Up"]]
			loaded_settings["MOVE_DOWN"] = [[InputMap.action_get_events("move_down")[0].physical_keycode,InputMap.action_get_events("move_down")[1].physical_keycode],["S","Down"]]
			loaded_settings["MOVE_LEFT"] = [[InputMap.action_get_events("move_left")[0].physical_keycode,InputMap.action_get_events("move_left")[1].physical_keycode],["A","Left"]]
			loaded_settings["MOVE_RIGHT"] = [[InputMap.action_get_events("move_right")[0].physical_keycode,InputMap.action_get_events("move_right")[1].physical_keycode],["D","Right"]]
			loaded_settings["INTERACT"] = [[InputMap.action_get_events("interact")[0].physical_keycode],["Shift","RMB"]]
			loaded_settings["CANCEL"] = [[InputMap.action_get_events("cancel")[0].physical_keycode,InputMap.action_get_events("cancel")[1].physical_keycode],["Tab","X"]]
			write_to_file(settings_file_path,loaded_settings)
		SAVE:
			var loaded_save = load_file(SAVE)
			#MAKE SURE GLOBAL VERSION IS CORRECT!
			loaded_save["VERSION"] = Globals.app_version
			#NEW FILE VALUES GO HERE
			
			write_to_file(save_file_path,loaded_save)
