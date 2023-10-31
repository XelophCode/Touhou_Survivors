extends Node2D

var level:int = 1
var reimu_blocked_spaces:Array = [1,2,3,4,5,6,7,9,13,15,16,17,18,19,20,21,23,27,30,34,37,41,44,48]
var cross_blocked_spaces:Array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,20,21,22,23,25,27,28,29,30,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49]

var hp_lower_range_rolls : Array = [Vector2(5,35),Vector2(25,45),Vector2(45,55),Vector2(55,65),Vector2(75,85)]
var hp_lower_range : Array = []
var hp_upper_range : Array = [50,60,70,80,99]
var hp_upgrade_val : float

var dmg_lower_range_rolls : Array = [Vector2(0,1),Vector2(1,2),Vector2(2,3),Vector2(2,4),Vector2(4,6)]
var dmg_lower_range : Array = []
var dmg_upper_range : Array = [3,4,5,7,9]
var dmg_upgrade_val : int

var spd_lower_range_rolls : Array = [Vector2(0,1),Vector2(0,2),Vector2(0,3),Vector2(0,4),Vector2(0,5)]
var spd_lower_range : Array = []
var spd_upper_range : Array = [2,3,4,5,6]
var spd_upgrade_val : float

var button_hovering : int = -1

enum {DMG,SPD,HP,REROLL,SPELLCARDS}

const black : Color = Color.BLACK
const grey : Color = Color.DIM_GRAY

@export var blocked_spaces : Node
@export var character_art : Node
@export var grid_art : Node
@export var reimu_char_art : Texture2D
@export var marisa_char_art : Texture2D
@export var remilia_char_art : Texture2D
@export var aya_char_art : Texture2D
@export var suika_char_art : Texture2D
@export var reisen_char_art : Texture2D
@export var youmu_char_art : Texture2D
@export var cirno_char_art : Texture2D

@export_group("nodes")
@export var hp_potential_label : Label
@export var hp_current_label : Label
@export var hp_plus : Sprite2D
@export var hp_line : Line2D
@export var hp_up_count : Node2D
@export var hp_anim : AnimationPlayer
@export var dmg_potential_label : Label
@export var dmg_current_label : Label
@export var dmg_plus : Sprite2D
@export var dmg_line : Line2D
@export var dmg_up_count : Node2D
@export var dmg_anim : AnimationPlayer
@export var spd_potential_label : Label
@export var spd_current_label : Label
@export var spd_plus : Sprite2D
@export var spd_line : Line2D
@export var spd_up_count : Node2D
@export var spd_anim : AnimationPlayer
@export var spell_card_overlay : Node2D
@export var collision_id : Node
@export var dmg_button_area : Area2D
@export var spd_button_area : Area2D
@export var hp_button_area : Area2D
@export var dmg_bg : ColorRect
@export var spd_bg : ColorRect
@export var hp_bg : ColorRect
@export var dmg_label : Label
@export var spd_label : Label
@export var hp_label : Label
@export var reroll_button_area : Area2D
@export var reroll_bg : ColorRect
@export var spellcard_button_area : Area2D
@export var spellcard_bg : ColorRect

func _ready():
	match Globals.current_character:
		Globals.Reimu: character_art.texture = reimu_char_art
		Globals.Marisa: character_art.texture = marisa_char_art
		Globals.Remilia: character_art.texture = remilia_char_art
		Globals.Aya: character_art.texture = aya_char_art
		Globals.Suika: character_art.texture = suika_char_art
		Globals.Reisen: character_art.texture = reisen_char_art
		Globals.Youmu: character_art.texture = youmu_char_art
		Globals.Cirno: character_art.texture = cirno_char_art
	Signals.connect("leveling_up",leveling_up)
	Signals.increase_max_hp.connect(catch_increase_max_hp)
	Signals.fade_ui.connect(catch_fade_ui)
	
	for i in cross_blocked_spaces:
		var space = $InventoryGrid.get_child(i-1).get_child(0)
		space.blocked = true
		space.monitoring = false
		space.monitorable = false
	
	for i in hp_lower_range_rolls:
		hp_lower_range.append(ceil(randf_range(i.x,i.y)))
	hp_potential_label.text = str(hp_lower_range[0]) + "-" + str(hp_upper_range[0])
	
	for i in dmg_lower_range_rolls:
		dmg_lower_range.append(randi_range(i.x,i.y))
	dmg_potential_label.text = str(dmg_lower_range[0]) + "-" + str(dmg_upper_range[0])
	
	for i in spd_lower_range_rolls:
		spd_lower_range.append(ceil(randf_range(i.x,i.y)))
	spd_potential_label.text = str(spd_lower_range[0]) + "-" + str(spd_upper_range[0])
	
	roll_all_upgrade_values()
	
	dmg_current_label.text = "DMG: +" + str(Globals.damage_bonus)
	spd_current_label.text = "SPD: " + str((Globals.speed_bonus/100) + 1)
	
	dmg_button_area.area_entered.connect(func(_area):
		if dmg_up_count.count > 0:
			button_hovering = DMG
			dmg_bg.color = grey)
	dmg_button_area.area_exited.connect(func(_area):
		if dmg_up_count.count > 0:
			button_hovering = -1
			dmg_bg.color = black
			Signals.show_interact_prompt.emit(false))
	spd_button_area.area_entered.connect(func(_area):
		if spd_up_count.count > 0:
			button_hovering = SPD
			spd_bg.color = grey)
	spd_button_area.area_exited.connect(func(_area):
		if spd_up_count.count > 0:
			button_hovering = -1
			spd_bg.color = black
			Signals.show_interact_prompt.emit(false))
	hp_button_area.area_entered.connect(func(_area):
		if hp_up_count.count > 0:
			button_hovering = HP
			hp_bg.color = grey)
	hp_button_area.area_exited.connect(func(_area):
		if hp_up_count.count > 0:
			button_hovering = -1
			hp_bg.color = black
			Signals.show_interact_prompt.emit(false))
	reroll_button_area.area_entered.connect(func(_area):
			button_hovering = REROLL
			reroll_bg.color = grey)
	reroll_button_area.area_exited.connect(func(_area):
			button_hovering = -1
			reroll_bg.color = black
			Signals.show_interact_prompt.emit(false))
	spellcard_button_area.area_entered.connect(func(_area):
			button_hovering = SPELLCARDS
			spellcard_bg.color = grey)
	spellcard_button_area.area_exited.connect(func(_area):
			button_hovering = -1
			spellcard_bg.color = black
			Signals.show_interact_prompt.emit(false))


func _process(delta):
	if spell_card_overlay.visible:
		if Input.is_action_just_pressed("left_mouse_button") or Input.is_action_just_pressed("a_button_press") or Input.is_action_just_pressed("b_button_press"):
			spell_card_overlay.hide()
			Signals.spell_card_overlay_visible.emit(false)
	else:
		if !Globals.holding_item:
			if !Input.is_action_pressed("b_button_press"):
				match button_hovering:
					DMG:
						Signals.show_interact_prompt.emit(true)
						if Input.is_action_just_pressed("left_mouse_button") or Input.is_action_just_pressed("a_button_press"):
							do_dmg_upgrade()
					SPD:
						Signals.show_interact_prompt.emit(true)
						if Input.is_action_just_pressed("left_mouse_button") or Input.is_action_just_pressed("a_button_press"):
							do_spd_upgrade()
					HP:
						Signals.show_interact_prompt.emit(true)
						if Input.is_action_just_pressed("left_mouse_button") or Input.is_action_just_pressed("a_button_press"):
							do_hp_upgrade()
					REROLL:
						Signals.show_interact_prompt.emit(true)
						if Input.is_action_just_pressed("left_mouse_button") or Input.is_action_just_pressed("a_button_press"):
							do_reroll()
					SPELLCARDS:
						Signals.show_interact_prompt.emit(true)
						if Input.is_action_just_pressed("left_mouse_button") or Input.is_action_just_pressed("a_button_press"):
							spell_card_overlay.show()
							Signals.spell_card_overlay_visible.emit(true)


func leveling_up(value:bool):
	if value:
		open_inventory()
		await get_tree().create_timer(1).timeout

	else:
		visible = false


func open_inventory():
	level += 1
	$AnimationPlayer.play("slide")
	visible = true

func slide_anim_finished():
	Signals.emit_signal("show_blocked_spaces")

func catch_fade_ui(fade):
	if fade:
		$AnimationPlayer2.play("fade_out")
	else:
		$AnimationPlayer2.play("fade_in")


func do_hp_upgrade():
	if Globals.crystal_count > 0:
		Globals.crystal_count -= 1.0
		Signals.emit_signal("decrease_crystal_count")
		Signals.upgrade_health.emit(hp_upgrade_val)
		hp_upper_range.pop_front()
		hp_lower_range.pop_front()
		hp_up_count.count -= 1
		roll_hp_upgrade()
	else:
		Signals.emit_signal("not_enough_crystals")


func catch_increase_max_hp(value:float):
	hp_current_label.text = "HP:" + str(ceil(value))


func roll_all_upgrade_values():
	roll_hp_upgrade()
	roll_dmg_upgrade()
	roll_spd_upgrade()


func roll_hp_upgrade():
	if hp_up_count.count > 0:
		hp_anim.play("flash")
		hp_potential_label.text = str(hp_lower_range[0]) + "-" + str(hp_upper_range[0])
		hp_upgrade_val = ceil(randf_range(hp_lower_range[0],hp_upper_range[0]))
		hp_label.text = "HP   " + str(hp_upgrade_val)
	else:
		hp_potential_label.text = "0"
		hp_label.text = ""
		hp_plus.hide()
		hp_line.show()
		button_hovering = -1
		hp_bg.color = black


func do_dmg_upgrade():
	if Globals.crystal_count > 0:
		Globals.crystal_count -= 1.0
		Signals.emit_signal("decrease_crystal_count")
		Globals.damage_bonus += dmg_upgrade_val
		dmg_current_label.text = "DMG: +" + str(Globals.damage_bonus)
		dmg_upper_range.pop_front()
		dmg_lower_range.pop_front()
		dmg_up_count.count -= 1
		roll_dmg_upgrade()
	else:
		Signals.emit_signal("not_enough_crystals")


func roll_dmg_upgrade():
	if dmg_up_count.count > 0:
		dmg_anim.play("flash")
		dmg_potential_label.text = str(dmg_lower_range[0]) + "-" + str(dmg_upper_range[0])
		dmg_upgrade_val = randi_range(dmg_lower_range[0],dmg_upper_range[0])
		dmg_label.text = "DMG   " + str(dmg_upgrade_val)
	else:
		dmg_potential_label.text = "0"
		dmg_label.text = ""
		dmg_plus.hide()
		dmg_line.show()
		button_hovering = -1
		dmg_bg.color = black


func do_spd_upgrade():
	if Globals.crystal_count > 0:
		Globals.crystal_count -= 1.0
		Signals.emit_signal("decrease_crystal_count")
		Globals.speed_bonus += (spd_upgrade_val * 100)
		spd_current_label.text = "SPD: " + str((Globals.speed_bonus/100) + 1)
		spd_upper_range.pop_front()
		spd_lower_range.pop_front()
		spd_up_count.count -= 1
		roll_spd_upgrade()
	else:
		Signals.emit_signal("not_enough_crystals")


func roll_spd_upgrade():
	if spd_up_count.count > 0:
		spd_anim.play("flash")
		spd_potential_label.text = str(spd_lower_range[0]) + "-" + str(spd_upper_range[0])
		spd_upgrade_val = ceil(randf_range(spd_lower_range[0],spd_upper_range[0]))
		spd_label.text = "SPD   " + str(spd_upgrade_val)
	else:
		spd_potential_label.text = "0"
		spd_label.text = ""
		spd_plus.hide()
		spd_line.show()
		button_hovering = -1
		spd_bg.color = black


func do_reroll():
	if Globals.crystal_count > 0:
		Globals.crystal_count -= 1.0
		Signals.emit_signal("decrease_crystal_count")
		roll_all_upgrade_values()
	else:
		Signals.emit_signal("not_enough_crystals")



