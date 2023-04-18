extends Node2D

@export var fullscreen_pink : Node
@export var main_game_scene : PackedScene

func _ready():
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(0.1).timeout
	AudioServer.set_bus_volume_db(0,Globals.audio_reset)

func _on_reimu_mouse_entered():
	$ReimuSprite.play("default")
	$Loadouts/Loadout.visible = true

func _on_reimu_mouse_exited():
	$ReimuSprite.stop()
	$Loadouts/Loadout.visible = false

func _on_marisa_mouse_entered():
	$MarisaSprite.play("default")
	$Loadouts/Loadout2.visible = true

func _on_marisa_mouse_exited():
	$MarisaSprite.stop()
	$Loadouts/Loadout2.visible = false

func _on_reimu_button_down():
	$Reimu.disabled = true
	Globals.current_character = Globals.Reimu
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")

func _on_marisa_button_down():
	$Marisa.disabled = true
	Globals.current_character = Globals.Marisa
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")

func go_to_main_game_scene():
	await get_tree().create_timer(0.5).timeout
	
	get_tree().change_scene_to_file("res://prefabs/levels/main.tscn")

func _on_remilia_button_down():
	$Remilia.disabled = true
	Globals.current_character = Globals.Remilia
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")

func _on_remilia_mouse_entered():
	$RemiliaSprite.play("default")
	$Loadouts/Loadout2.visible = true

func _on_remilia_mouse_exited():
	$RemiliaSprite.stop()
	$Loadouts/Loadout2.visible = false


func _on_aya_button_down():
	$Aya.disabled = true
	Globals.current_character = Globals.Aya
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")

func _on_aya_mouse_entered():
	$AyaSprite.play("default")
	$Loadouts/Loadout2.visible = true

func _on_aya_mouse_exited():
	$AyaSprite.stop()
	$Loadouts/Loadout2.visible = false
