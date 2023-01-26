extends Camera2D

@onready var shop = preload("res://prefabs/logic_ui/shop.tscn")
@onready var inventory = preload("res://prefabs/logic_ui/Inventory.tscn")
@onready var shop_close_button = preload("res://prefabs/logic_ui/shop_close_button.tscn")

var max_power:float = 1
var power:float
var camera_is_tweening:bool = false
var camera_gap_pos:Vector2
var current_orb_target : int
var level:int = 1
var play_time_second:float
var play_time_minute:int

func _ready():
	Signals.connect("update_power",update_power)
	Signals.connect("update_faith",update_occult_orbs)
	Signals.connect("leveling_up",leveling_up)
	Signals.connect("gap_camera_tween",gap_camera_tween)
	Signals.connect("player_damaged",damage_animation)
	
	for child in $OccultOrbParent.get_children():
		child.get_child(1).max_value = Globals.occult_orb_max
	

func _process(delta):
	if !Globals.leveling_up:
		play_time_second += delta
		var play_time_floored = floor(play_time_second)
		if play_time_floored > 59:
			play_time_second = 0.0
			play_time_minute += 1
		
		var play_time_stringed:String
		if play_time_floored < 10:
			play_time_stringed = str(play_time_minute) + ":0" + str(play_time_floored)
		else :
			play_time_stringed = str(play_time_minute) + ":" + str(play_time_floored)
		$Time.text = str(play_time_stringed)
		

func _physics_process(delta):
	if !camera_is_tweening:
		global_position = Globals.player_position
	else:
		global_position = lerp(global_position,camera_gap_pos,delta * 8)
		$Powerbar.position = Vector2(-211,-119)
		$PowerbarBorder.position = Vector2(0,-112)
		if global_position.distance_to(camera_gap_pos) < 0.5:
			gap_finish()
	$Powerbar.value = power
	$Powerbar.max_value = max_power
	if power >= max_power:
		open_inventory()

func open_inventory():
	level += 1
	match level:
		5: $Inventory.current_tier = $Inventory.tier_two; $Inventory.get_node("ReimuInventoryGrid/BlockedSpaces").texture = $Inventory.blocked_spaces_tier_2
		10: $Inventory.current_tier = $Inventory.tier_three; $Inventory.get_node("ReimuInventoryGrid/BlockedSpaces").texture = $Inventory.blocked_spaces_tier_3
		15: $Inventory.current_tier = $Inventory.tier_four; $Inventory.get_node("ReimuInventoryGrid/BlockedSpaces").texture = $Inventory.blocked_spaces_tier_4
		20: $Inventory.current_tier = $Inventory.tier_five; $Inventory.get_node("ReimuInventoryGrid/BlockedSpaces").visible = false
		_:pass
	$Level.text = "LVL " + str(level)
	$Inventory.open_inventory()
	$Shop.open_shop()
	max_power *= 1.5
	max_power = ceil(max_power)
	power = 0
	Signals.emit_signal("leveling_up",true)
	Globals.leveling_up = true

func update_power(value:float):
	power += value

func leveling_up(value):
	if value:
		$shop_close_button.visible = true
		$PortraitAnims.stop()
		$ReimuPortrait.play("smile")
		$ScreenDim.visible = true
		$AnimationPlayer.play("screen_dim")
		$Threat.paused = true
		print(str($Threat.time_left))
	else:
		$PortraitAnims.start()
		$ReimuPortrait.play("head_bob")
		$ScreenDim.visible = false
		print(str($Threat.time_left))
		$Threat.paused = false

func gap_camera_tween(destination:Vector2):
	camera_is_tweening = true
	camera_gap_pos = destination

func gap_finish():
	Signals.emit_signal("gap_finish")
	camera_is_tweening = false


func _on_reimu_portrait_animation_finished():
	$ReimuPortrait.stop()
	if $ReimuPortrait.animation == "head_bob":
		$ReimuPortrait.frame = 0
	if $ReimuPortrait.animation == "smile":
		$ReimuPortrait.frame = 3
	if $ReimuPortrait.animation == "damage":
		$ReimuPortrait.frame = 0
	if $ReimuPortrait.animation == "blink":
		$ReimuPortrait.frame = 0


func damage_animation():
	$ReimuPortrait.play("damage")

func _on_button_button_down():
	Globals.leveling_up = false
	Signals.emit_signal("leveling_up",false)
	$shop_close_button.visible = false

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

func _on_portrait_anims_timeout():
	var random_anim:Array = ["head_bob","blink"]
	$ReimuPortrait.play(random_anim.pick_random())

func _on_threat_timeout():
	Signals.emit_signal("increase_threat")
