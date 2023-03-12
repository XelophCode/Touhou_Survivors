extends CanvasLayer

@export var main_menu : PackedScene
@export var character_portrait : Node
@export var time_label : Node
@export var lvl_label : Node
@export var powerbar : Node
@export var confetti : Node
@export var reimu_portrait : SpriteFrames
@export var marisa_portrait : SpriteFrames

var music_muted:bool = false
var playtime_second:float
var playtime_minute:float
var power:float
var power_update:float
var faith:float
var faith_update:float
var current_orb_target:int
var leveling_up:bool = false
var occult_orb_max:float = 10.0
var current_lvl:int = 1
var escape_can_unpause:bool = false
var crystal:float
var crystal_count:float
var is_paused:bool = false:
	set(value):
		is_paused = value
		$PauseMenu.visible = is_paused
		get_tree().paused = is_paused
		await get_tree().create_timer(0.1).timeout
		escape_can_unpause = is_paused

func _ready():
	Globals.crystal_count = 0
	$AnimationPlayer.play("fade_out")
	match Globals.current_character:
		Globals.Reimu: character_portrait.sprite_frames = reimu_portrait
		Globals.Marisa: character_portrait.sprite_frames = marisa_portrait
	
	Signals.connect("current_power",catch_current_power)
	Signals.connect("next_lvl_update",catch_next_lvl_update)
	Signals.connect("leveling_up",catch_leveling_up)
	Signals.connect("game_over",catch_game_over)
	Signals.connect("increase_max_hp",catch_increase_max_hp)
	Signals.connect("update_crystal",catch_update_crystal)
	Signals.connect("decrease_crystal_count",catch_decrease_crystal_count)
	Signals.connect("not_enough_crystals",catch_not_enough_crystals)
	Signals.connect("taking_damage",catch_taking_damage)



func _process(delta):
	$UI/Crystalbar.value = lerp($UI/Crystalbar.value, crystal, delta*2)
	if Input.is_action_just_pressed("escape"):
		is_paused = !is_paused
	
	$UI/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	
	power = lerp(power,power_update,delta*4)
	powerbar.value = power
	
	if !leveling_up:
		playtime_second += delta
		var playtime_floored = floor(playtime_second)
		if playtime_floored > 59:
			playtime_second = 0.0
			playtime_minute += 1
		
		var playtime_stringed:String
		if playtime_floored < 10:
			playtime_stringed = str(playtime_minute) + ":0" + str(playtime_floored)
		else :
			playtime_stringed = str(playtime_minute) + ":" + str(playtime_floored)
		time_label.text = str(playtime_stringed)
		$UI/Time2.text = str(playtime_stringed)
	
	$UI/Healthbar.value = Globals.player_hp
	

func _on_portrait_anims_timeout():
	var random_anim:Array = ["head_bob","blink"]
	character_portrait.play(random_anim.pick_random())

func _on_character_portrait_animation_finished():
	if character_portrait.animation == "head_bob":
		character_portrait.frame = 0
	if character_portrait.animation == "smile":
		character_portrait.frame = 3
	if character_portrait.animation == "damage":
		character_portrait.frame = 0
	if character_portrait.animation == "blink":
		character_portrait.frame = 0

func catch_current_power(value):
	power_update = value

func catch_next_lvl_update(value):
	powerbar.max_value = value

func catch_leveling_up(value):
	leveling_up = value
	if leveling_up:
		$ScreenDim.visible = true
		$AnimationPlayer2.play("dim_screen")
		confetti.emitting = true
		character_portrait.play("smile")
		$PortraitAnims.stop()
		current_lvl += 1
		lvl_label.text = "Lvl " + str(current_lvl)
	else:
		$ScreenDim.visible = false
		confetti.emitting = false
		character_portrait.play("head_bob")
		$PortraitAnims.start()


func _on_resume_button_down():
	is_paused = false
	$Audio/select.play()

func _on_main_menu_button_up():
	is_paused = false
	goto_main_menu()


func _on_check_box_toggled(_button_pressed):
	music_muted = !music_muted
	AudioServer.set_bus_mute(1,music_muted)

func catch_game_over():
	$AnimationPlayer.play("gameover")

func goto_main_menu():
	get_tree().change_scene_to_file("res://prefabs/levels/main_menu.tscn")

func catch_increase_max_hp(value):
	$UI/Healthbar.max_value = value

func catch_update_crystal(value):
	crystal += value
	if crystal >= $UI/Crystalbar.max_value:
		if Globals.crystal_count >= 9.0:
			crystal = $UI/Crystalbar.max_value
		else:
			$UI/shard_count.material.set_shader_parameter("flash_color",Color(1,1,1,1))
			$AnimationPlayer3.play("crystal_number_flash")
			crystal = 0
			Globals.crystal_count += 1.0
			Globals.crystal_count = clamp(Globals.crystal_count,0,9.0)
			$UI/shard_count.frame = Globals.crystal_count
			$UI/Crystalbar.max_value = scale_max_crystal()

func scale_max_crystal():
	var max_crystal:float = 0
	match Globals.crystal_count:
		0.0: max_crystal = 10
		1.0: max_crystal = 11
		2.0: max_crystal = 12
		3.0: max_crystal = 14
		4.0: max_crystal = 16
		5.0: max_crystal = 18
		6.0: max_crystal = 20
		7.0: max_crystal = 24
		8.0: max_crystal = 28
		9.0: max_crystal = 34
	return max_crystal

func catch_decrease_crystal_count():
	$UI/shard_count.frame = Globals.crystal_count
	$UI/shard_count.material.set_shader_parameter("flash_color",Color(1,1,1,1))
	$AnimationPlayer3.play("crystal_number_flash")
	$UI/Crystalbar.max_value = scale_max_crystal()

func catch_not_enough_crystals():
	$UI/shard_count.material.set_shader_parameter("flash_color",Color(1,0,0,1))
	$AnimationPlayer3.play("number_flash_red_shake")

func _on_crystal_anim_timeout():
	$UI/Crystal.play("default")

func play_damage_modulate():
	$damage_screen.play("modulate")

func catch_taking_damage(value):
	if value:
		$damage_screen.play("fade_in")
		$damage_shake.play("shake")
		character_portrait.play("damage")
	else:
		$damage_screen.play("fade_out")
