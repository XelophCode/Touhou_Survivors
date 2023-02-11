extends CanvasLayer

@export var character_portrait : Node
@export var time_label : Node
@export var lvl_label : Node
@export var powerbar : Node

var playtime_second:float
var playtime_minute:float
var power:float
var power_update:float
var current_orb_target:float
var leveling_up:bool = false

func _ready():
	Signals.connect("current_power",catch_current_power)
	Signals.connect("next_lvl_update",catch_next_lvl_update)
	Signals.connect("leveling_up",catch_leveling_up)

func _process(delta):
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

func _on_portrait_anims_timeout():
	var random_anim:Array = ["head_bob","blink"]
	character_portrait.play(random_anim.pick_random())

func _on_character_portrait_animation_finished():
	character_portrait.stop()
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
