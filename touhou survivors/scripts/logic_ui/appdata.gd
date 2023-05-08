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

func save_file_write_new(file_name:int):
	match file_name:
		SETTINGS:
			settings = {
				"RESOLUTION" = Vector2(1280,720),
				"WINDOW_MODE" = 0,
				"MONITOR" = 0,
				"MASTER_AUDIO" = -10.0,
				"MUSIC_AUDIO" = -10.0,
				"SFX_AUDIO" = -5.0,
				"ITEM_AUDIO" = -5.0,
				"SHOW_FPS" = false
			}
			write_to_file(settings_file_path,settings)
		SAVE:
			save = {
				"LOCKED_CHARACTERS" = ["Remilia","Aya","Suika","Reisen","Youmu"],
				"MON" = 9000,
				"BEST_TIME_NUM" = 0,
				"BEST_TIME_STRING" = "0:00",
				"DEATHS" = 0,
				"MON_LIFETIME" = 9000,
				"FAITH_LIFETIME" = 0,
				"CRYSTALS_LIFETIME" = 0,
				"ITEMS_USED" = 0,
				"SPELLCARDS_USED" = 0,
				"ALL_SPELLCARDS" = 0,
				"LILY_WHITE" = 0,
				"DAIYOUSEI" = 0
			}
			write_to_file(save_file_path,save)
