extends Node2D

@export var main_menu_bg : Node
@export var main_menu_logo : Node
@export var main_animation_player : Node
@export var button_anims : Node
@export var character_select : PackedScene
var reset_audio_DB:float

func _ready():
	var tween = create_tween()
	tween.tween_property($Audio/music,"volume_db",0.0,3)

func _process(_delta):
	if !$PressStart.visible and !$Buttons.visible:
		if Globals.any_input_just_pressed():
			main_animation_player.stop()
			main_menu_bg.position.y = 480
			$FullscreenWhite.visible = false
			main_menu_logo.position.y = -360
			main_menu_logo.material.set_shader_parameter("dissolve_value",1.0)
			main_menu_logo.material.set_shader_parameter("flash_modifier",0.0)
			main_menu_logo.material.set_shader_parameter("opacity",1.0)
			show_press_start()
	elif $PressStart.visible and !$Buttons.visible:
		if Globals.any_input_just_pressed():
			$Buttons.visible = true
			$PressStart.visible = false
			$Audio/select.play()

func fade_in_logo():
	main_animation_player.play("logo_fade_in")

func show_press_start():
	$PressStart.visible = true
	main_animation_player.play("press_start")

func _on_start_button_down():
	$Audio/select.play()
	button_anims.play("start")
	await get_tree().create_timer(0.3).timeout
	$SakuraFade.play("Sakura")
#	$BlackFade.play("fade_in")
	Globals.audio_reset = AudioServer.get_bus_volume_db(0)
	var tween = create_tween()
	tween.tween_method(fade_audio,AudioServer.get_bus_volume_db(0),-60,1.9)
	

func go_to_character_select():
	await get_tree().create_timer(0.5).timeout
	
	get_tree().change_scene_to_file("res://prefabs/levels/character_select.tscn")

func fade_audio(value:float):
	AudioServer.set_bus_volume_db(0,value)

func _on_quit_button_down():
	$Audio/select.play()
	button_anims.play("quit")
	await get_tree().create_timer(0.3).timeout
	$BlackFade.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

