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
var is_paused:bool = false:
	set(value):
		is_paused = value
		$PauseMenu.visible = is_paused
		get_tree().paused = is_paused
		await get_tree().create_timer(0.1).timeout
		escape_can_unpause = is_paused

var current_orb:int:
	set(value):
		current_orb = value
		Signals.emit_signal("update_orb_count",current_orb)

func _ready():
	$AnimationPlayer.play("fade_out")
	match Globals.current_character:
		Globals.Reimu: character_portrait.sprite_frames = reimu_portrait
		Globals.Marisa: character_portrait.sprite_frames = marisa_portrait
	
	Signals.connect("current_power",catch_current_power)
	Signals.connect("next_lvl_update",catch_next_lvl_update)
	Signals.connect("leveling_up",catch_leveling_up)
	Signals.connect("current_faith",catch_current_faith)
	Signals.connect("reduce_orb_count",catch_reduce_orb_count)
	Signals.connect("game_over",catch_game_over)
	
	for orb in $UI/OccultOrbParent.get_children():
		orb.get_child(1).max_value = occult_orb_max

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		is_paused = !is_paused
	
	$UI/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	
	power = lerp(power,power_update,delta*4)
	powerbar.value = power
	
	faith = lerp(faith,faith_update,delta*4)
	if faith > occult_orb_max:
		current_orb = 1
		if faith > occult_orb_max * 2:
			current_orb = 2
			if faith > occult_orb_max * 3:
				current_orb = 3
				if faith > occult_orb_max * 4:
					current_orb = 4
	else:
		current_orb = 0
	$UI/OccultOrbParent.get_child(current_orb).get_child(1).value = faith - occult_orb_max * current_orb
	
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

func catch_current_faith(value):
	faith_update = value

func catch_current_power(value):
	power_update = value

func catch_next_lvl_update(value):
	powerbar.max_value = value

func update_occult_orbs():
	var old_orb_target = current_orb_target
	if Globals.faith > Globals.occult_orb_max:
		current_orb_target = 1
		if Globals.faith > Globals.occult_orb_max * 2:
			current_orb_target = 2
			if Globals.faith > Globals.occult_orb_max * 3:
				current_orb_target = 3
				if Globals.faith > Globals.occult_orb_max * 4:
					current_orb_target = 4
	else:
		current_orb_target = 0
	
	if old_orb_target > current_orb_target:
		$OccultOrbParent.get_child(old_orb_target).get_child(1).value = 0
	
	$OccultOrbParent.get_child(current_orb_target).get_child(1).value = Globals.faith - Globals.occult_orb_max * current_orb_target

func catch_leveling_up(value):
	leveling_up = value
	if leveling_up:
		confetti.emitting = true
		character_portrait.play("smile")
		$PortraitAnims.stop()
		current_lvl += 1
		lvl_label.text = "Lvl " + str(current_lvl)
	else:
		confetti.emitting = false
		character_portrait.play("head_bob")
		$PortraitAnims.start()

func catch_reduce_orb_count():
	Signals.emit_signal("update_faith",-occult_orb_max)

func _on_resume_button_down():
	is_paused = false
	$Audio/select.play()

func _on_main_menu_button_up():
	is_paused = false
	goto_main_menu()


func _on_check_box_toggled(button_pressed):
	music_muted = !music_muted
	AudioServer.set_bus_mute(1,music_muted)

func catch_game_over():
	$AnimationPlayer.play("gameover")

func goto_main_menu():
	get_tree().change_scene_to_file("res://prefabs/levels/main_menu.tscn")
