extends Node2D

@export var fullscreen_pink : Node
@export var main_game_scene : PackedScene

func _ready():
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(0.1).timeout
	AudioServer.set_bus_volume_db(0,Globals.audio_reset)

func _on_reimu_mouse_entered():
	$ReimuSprite.play("default")
	$Loadout.visible = true

func _on_reimu_mouse_exited():
	$ReimuSprite.stop()
	$Loadout.visible = false

func _on_marisa_mouse_entered():
	$MarisaSprite.play("default")
	$Loadout2.visible = true

func _on_marisa_mouse_exited():
	$MarisaSprite.stop()
	$Loadout2.visible = false

func _on_reimu_button_down():
	Globals.current_character = Globals.Reimu
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")

func _on_marisa_button_down():
	Globals.current_character = Globals.Marisa
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")

func go_to_main_game_scene():
	await get_tree().create_timer(0.5).timeout
	
	get_tree().change_scene_to_file("res://prefabs/levels/main.tscn")
