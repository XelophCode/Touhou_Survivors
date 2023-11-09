extends Node2D

@export var fullscreen_pink : Node

@export_group("character_buttons")
@export var reimu_button : Button
@export var marisa_button : Button
@export var remilia_button : Button
@export var aya_button : Button
@export var suika_button : Button
@export var reisen_button : Button
@export var youmu_button : Button
@export var cirno_button : Button

@export_group("character_sprites")
@export var reimu_sprite : AnimatedSprite2D
@export var marisa_sprite : AnimatedSprite2D
@export var remilia_sprite : AnimatedSprite2D
@export var aya_sprite : AnimatedSprite2D
@export var suika_sprite : AnimatedSprite2D
@export var reisen_sprite : AnimatedSprite2D
@export var youmu_sprite : AnimatedSprite2D
@export var cirno_sprite : AnimatedSprite2D

@export_group("character_loadouts")
@export var reimu_loadout : Node2D
@export var marisa_loadout : Node2D
@export_subgroup("remilia")
@export var remilia_loadout : Node2D
@export var remilia_portrait : Sprite2D
@export var remilia_info : Node2D
@export_subgroup("aya")
@export var aya_loadout : Node2D
@export var aya_portrait : Sprite2D
@export var aya_info : Node2D
@export_subgroup("suika")
@export var suika_loadout : Node2D
@export var suika_portrait : Sprite2D
@export var suika_info : Node2D
@export_subgroup("reisen")
@export var reisen_loadout : Node2D
@export var reisen_portrait : Sprite2D
@export var reisen_info : Node2D
@export_subgroup("youmu")
@export var youmu_loadout : Node2D
@export var youmu_portrait : Sprite2D
@export var youmu_info : Node2D
@export_subgroup("cirno")
@export var cirno_loadout : Node2D
@export var cirno_portrait : Sprite2D
@export var cirno_info : Node2D

@export_group("misc")
@export var mon_label : Label
@export var cost : Node2D
@export var item_disable_cost_label : Label
@export var item_disable_cost : Node2D
@export var anim_player_2 : AnimationPlayer
@export var item_dis_count : Label
@export var hidden_button : Button

var mon : int = 0:
	set(value):
		mon = clamp(value,0,999999)

var locked_characters : Array
var disabled_items : Array = []
var all_chars_unlocked = false

func _ready():
	var loaded_settings = Appdata.load_file(Appdata.SETTINGS)
	$CanvasLayer/FPS.visible = loaded_settings.SHOW_FPS
	Globals.disabled_items = []
	$AnimationPlayer.play("fade_out")
	var loaded_save = Appdata.load_file(Appdata.SAVE)
	mon = loaded_save.MON
	mon_label.text = str(mon)
	locked_characters = loaded_save.LOCKED_CHARACTERS
	
	if locked_characters == []:
		all_chars_unlocked = true
	
	for char_name in locked_characters:
		match char_name:
			"Remilia":
				remilia_portrait.material.set_shader_parameter("flash_modifier",1.0)
				remilia_sprite.material.set_shader_parameter("flash_modifier",1.0)
				remilia_info.visible = false
			"Suika":
				suika_portrait.material.set_shader_parameter("flash_modifier",1.0)
				suika_sprite.material.set_shader_parameter("flash_modifier",1.0)
				suika_info.visible = false
			"Aya":
				aya_portrait.material.set_shader_parameter("flash_modifier",1.0)
				aya_sprite.material.set_shader_parameter("flash_modifier",1.0)
				aya_info.visible = false
			"Reisen":
				reisen_portrait.material.set_shader_parameter("flash_modifier",1.0)
				reisen_sprite.material.set_shader_parameter("flash_modifier",1.0)
				reisen_info.visible = false
			"Youmu":
				youmu_portrait.material.set_shader_parameter("flash_modifier",1.0)
				youmu_sprite.material.set_shader_parameter("flash_modifier",1.0)
				youmu_info.visible = false
			"Cirno":
				cirno_portrait.material.set_shader_parameter("flash_modifier",1.0)
				cirno_sprite.material.set_shader_parameter("flash_modifier",1.0)
				cirno_info.visible = false
	
	
	Globals.connect_mouse_and_focus(reimu_button,reimu_entered,reimu_exited)
	Globals.connect_mouse_and_focus(marisa_button,marisa_entered,marisa_exited)
	Globals.connect_mouse_and_focus(remilia_button,remilia_entered,remilia_exited)
	Globals.connect_mouse_and_focus(aya_button,aya_entered,aya_exited)
	Globals.connect_mouse_and_focus(suika_button,suika_entered,suika_exited)
	Globals.connect_mouse_and_focus(reisen_button,reisen_entered,reisen_exited)
	Globals.connect_mouse_and_focus(youmu_button,youmu_entered,youmu_exited)
	Globals.connect_mouse_and_focus(cirno_button,cirno_entered,cirno_exited)

func _process(_delta):
	$CanvasLayer/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	item_disable_cost.position.x = get_global_mouse_position().x
	item_disable_cost.position.y = get_global_mouse_position().y
	
	if !all_chars_unlocked:
		if locked_characters == []:
			Steam.setAchievement("ach_all_characters")
			Steam.storeStats()
			all_chars_unlocked = true

func check_for_unlock(char_name:String):
	if mon >= 1000:
		mon -= 1000
		locked_characters.erase(char_name)
		match char_name:
			"Remilia": 
				remilia_portrait.material.set_shader_parameter("flash_modifier",0.0)
				remilia_sprite.material.set_shader_parameter("flash_modifier",0.0)
				remilia_info.visible = true
			"Suika": 
				suika_portrait.material.set_shader_parameter("flash_modifier",0.0)
				suika_sprite.material.set_shader_parameter("flash_modifier",0.0)
				suika_info.visible = true
			"Aya": 
				aya_portrait.material.set_shader_parameter("flash_modifier",0.0)
				aya_sprite.material.set_shader_parameter("flash_modifier",0.0)
				aya_info.visible = true
			"Reisen": 
				reisen_portrait.material.set_shader_parameter("flash_modifier",0.0)
				reisen_sprite.material.set_shader_parameter("flash_modifier",0.0)
				reisen_info.visible = true
			"Youmu": 
				youmu_portrait.material.set_shader_parameter("flash_modifier",0.0)
				youmu_sprite.material.set_shader_parameter("flash_modifier",0.0)
				youmu_info.visible = true
			"Cirno": 
				cirno_portrait.material.set_shader_parameter("flash_modifier",0.0)
				cirno_sprite.material.set_shader_parameter("flash_modifier",0.0)
				cirno_info.visible = true
		cost.visible = false
		mon_label.text = str(mon)
	else:
		$AnimationPlayer2.play("not_enough_mon")

func update_save():
	Appdata.save_file(Appdata.SAVE,"MON",mon)
	Appdata.save_file(Appdata.SAVE,"LOCKED_CHARACTERS",locked_characters)


func _on_reimu_button_down():
	$disable_all.visible = true
	Globals.current_character = Globals.Reimu
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")
	update_save()

func _on_marisa_button_down():
	$disable_all.visible = true
	Globals.current_character = Globals.Marisa
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")
	update_save()

func go_to_main_game_scene():
	initialize_character()
	
	SceneManager.change_scene(SceneManager.main_game,self)

func initialize_character():
	match Globals.current_character:
		Globals.Reimu : Globals.starting_hp_bonus = 100; Globals.damage_bonus = 2; Globals.speed_bonus = 200;
		Globals.Marisa : Globals.starting_hp_bonus = 0; Globals.damage_bonus = 2; Globals.speed_bonus = 500;
		Globals.Remilia : Globals.starting_hp_bonus = 200; Globals.damage_bonus = 0; Globals.speed_bonus = 200;
		Globals.Aya : Globals.starting_hp_bonus = 0; Globals.damage_bonus = 0; Globals.speed_bonus = 600;
		Globals.Suika : Globals.starting_hp_bonus = 150; Globals.damage_bonus = 4; Globals.speed_bonus = 0;
		Globals.Reisen : Globals.starting_hp_bonus = 100; Globals.damage_bonus = 1; Globals.speed_bonus = 300;
		Globals.Youmu : Globals.starting_hp_bonus = 0; Globals.damage_bonus = 3; Globals.speed_bonus = 400;
		Globals.Cirno : Globals.starting_hp_bonus = 0; Globals.damage_bonus = 0; Globals.speed_bonus = 0;
		

func _on_remilia_button_down():
	if locked_characters.has("Remilia"):
		check_for_unlock("Remilia")
		return
	else:
		$disable_all.visible = true
		Globals.current_character = Globals.Remilia
		$Loadouts.visible = false
		$Audio/select.play()
		$AnimationPlayer.play("fade_in")
		update_save()


func _on_aya_button_down():
	if locked_characters.has("Aya"):
		check_for_unlock("Aya")
		return
	$disable_all.visible = true
	Globals.current_character = Globals.Aya
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")
	update_save()



func _on_suika_button_down():
	if locked_characters.has("Suika"):
		check_for_unlock("Suika")
		return
	$disable_all.visible = true
	Globals.current_character = Globals.Suika
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")
	update_save()



func _on_reisen_button_down():
	if locked_characters.has("Reisen"):
		check_for_unlock("Reisen")
		return
	$disable_all.visible = true
	Globals.current_character = Globals.Reisen
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")
	update_save()



func _on_youmu_button_down():
	if locked_characters.has("Youmu"):
		check_for_unlock("Youmu")
		return
	$disable_all.visible = true
	Globals.current_character = Globals.Youmu
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")
	update_save()



func show_item_disable_cost(show_val:bool):
	item_disable_cost.visible = show_val

func _on_cirno_button_down():
	if locked_characters.has("Cirno"):
		check_for_unlock("Cirno")
		return
	$disable_all.visible = true
	Globals.current_character = Globals.Cirno
	$Loadouts.visible = false
	$Audio/select.play()
	$AnimationPlayer.play("fade_in")
	update_save()




func _on_main_menu_button_up():
	Globals.disabled_items = []
	await get_tree().create_timer(0.1).timeout
	
	SceneManager.change_scene(SceneManager.main_menu,self)


func reimu_entered():
	reimu_sprite.play("default")
	reimu_loadout.visible = true
func reimu_exited():
	reimu_sprite.stop()
	reimu_loadout.visible = false


func marisa_entered():
	marisa_sprite.play("default")
	marisa_loadout.visible = true
func marisa_exited():
	marisa_sprite.stop()
	marisa_loadout.visible = false


func remilia_entered():
	remilia_sprite.play("default")
	remilia_loadout.visible = true
	if locked_characters.has("Remilia"):
		cost.visible = true
	else:
		remilia_info.visible = true
func remilia_exited():
	remilia_sprite.stop()
	remilia_loadout.visible = false
	cost.visible = false


func aya_entered():
	aya_sprite.play("default")
	aya_loadout.visible = true
	if locked_characters.has("Aya"):
		cost.visible = true
	else:
		aya_info.visible = true
func aya_exited():
	aya_sprite.stop()
	aya_loadout.visible = false
	cost.visible = false


func suika_entered():
	suika_sprite.play("default")
	suika_loadout.visible = true
	if locked_characters.has("Suika"):
		cost.visible = true
	else:
		suika_info.visible = true
func suika_exited():
	suika_sprite.stop()
	suika_loadout.visible = false
	cost.visible = false


func reisen_entered():
	reisen_sprite.play("default")
	reisen_loadout.visible = true
	if locked_characters.has("Reisen"):
		cost.visible = true
	else:
		reisen_info.visible = true
func reisen_exited():
	reisen_sprite.stop()
	reisen_loadout.visible = false
	cost.visible = false


func youmu_entered():
	youmu_sprite.play("default")
	youmu_loadout.visible = true
	if locked_characters.has("Youmu"):
		cost.visible = true
	else:
		youmu_info.visible = true
func youmu_exited():
	youmu_sprite.stop()
	youmu_loadout.visible = false
	cost.visible = false


func cirno_entered():
	cirno_sprite.play("default")
	cirno_loadout.visible = true
	if locked_characters.has("Cirno"):
		cost.visible = true
	else:
		cirno_info.visible = true
func cirno_exited():
	cirno_sprite.stop()
	cirno_loadout.visible = false
	cost.visible = false


func focus_hidden_button():
	hidden_button.grab_focus()





