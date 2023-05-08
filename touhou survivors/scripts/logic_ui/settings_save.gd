extends Node

func _ready():
	Signals.connect("save_video_settings",catch_save_video_settings)
	Signals.connect("save_progress",catch_save_progress)

func save_file(player_data,file_path):
	var file = FileAccess.open(file_path,FileAccess.WRITE)
	file.store_var(player_data)

func catch_save_video_settings(video_settings,file_path):
	save_file(video_settings,file_path)

func catch_save_progress(progress,file_path):
	pass
