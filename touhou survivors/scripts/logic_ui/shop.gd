extends Node2D

enum {_1x1,_1x2,_1x3,_2x2,_2x3}
var eyes_scrolling : float

enum ITEMS {bat,camera,frog,gohei,haniwa,amulet,icicle,keystone,fan,bow,bomb,broom,tome,megaphone,hakkero,mallet,mushroom,wand,roukanken,sake,shanghai,knife,tripod,yinyang,umbrella,needle,rod}

@export var inv_items : all_items
var rerolling:bool = false
var can_reroll:bool = false
var spawn_count:Vector2 = Vector2(1,2)
var player_level:float = 1.0
var inventory_items:Array
var lvling_up:bool = false

func _ready():
	Signals.connect("leveling_up",leveling_up)
	inventory_items = inv_items.items
	for i in Globals.disabled_items:
		var item_id : int
		match i:
			ITEMS.bat: item_id = 0
			ITEMS.camera: item_id = 1
			ITEMS.frog: item_id = 2
			ITEMS.gohei: item_id = 4
			ITEMS.haniwa: item_id = 5
			ITEMS.amulet: item_id = 6
			ITEMS.icicle: item_id = 7
			ITEMS.keystone: item_id = 8
			ITEMS.fan: item_id = 28
			ITEMS.bow: item_id = 27
			ITEMS.bomb: item_id = 9
			ITEMS.broom: item_id = 10
			ITEMS.tome: item_id = 23
			ITEMS.megaphone: item_id = 26
			ITEMS.hakkero: item_id = 11
			ITEMS.mallet: item_id = 12
			ITEMS.mushroom: item_id = 25
			ITEMS.wand: item_id = 24
			ITEMS.roukanken: item_id = 17
			ITEMS.sake: item_id = 18
			ITEMS.shanghai: item_id = 19
			ITEMS.knife: item_id = 20
			ITEMS.tripod: item_id = 29
			ITEMS.yinyang: item_id = 21
			ITEMS.umbrella: item_id = 22
			ITEMS.needle: item_id = 14
			ITEMS.rod: item_id = 15
		inventory_items[item_id].enabled = false

func open_shop():
	rerolling = false
	var items1x1:Array = []
	var items1x2:Array = []
	var items1x3:Array = []
	var items2x2:Array = []
	var items2x3:Array = []
	
	for item in inventory_items:
		if item.enabled:
			match item.inventory_size:
				_1x1: items1x1.append(item)
				_1x2: items1x2.append(item)
				_1x3: items1x3.append(item)
				_2x2: items2x2.append(item)
				_2x3: items2x3.append(item)
	
	var items_to_spawn:Array = []
	var counter = 0
	for x1 in 6:
		var item = items1x1.pick_random()
		var inst = item.inventory.instantiate()
		pass_metadata_to_item(inst, item)
		
		var shop_offset:Vector2 = Vector2(0,0)
		match counter:
			0: shop_offset = $ShopGrid.get_child(8).position
			1: shop_offset = $ShopGrid.get_child(20).position
			2: shop_offset = $ShopGrid.get_child(19).position
			3: shop_offset = $ShopGrid.get_child(14).position
			4: shop_offset = $ShopGrid.get_child(2).position
			5: shop_offset = $ShopGrid.get_child(0).position
		inst.global_position = shop_offset
		items_to_spawn.append(inst)
		counter += 1
	
	counter = 0
	for x2 in 2:
		var item = items1x2.pick_random()
		var inst = item.inventory.instantiate()
		pass_metadata_to_item(inst, item)
		
		var shop_offset = Vector2(0,0)
		match counter:
			0: shop_offset = $ShopGrid.get_child(17).position
			1: shop_offset = $ShopGrid.get_child(18).position
		inst.global_position = shop_offset
		items_to_spawn.append(inst)
		counter += 1
	
	var item = items1x3.pick_random()
	var inst = item.inventory.instantiate()
	pass_metadata_to_item(inst, item)
	var shop_offset = $ShopGrid.get_child(1).position
	inst.global_position = shop_offset
	items_to_spawn.append(inst)
	
	item = items2x2.pick_random()
	inst = item.inventory.instantiate()
	pass_metadata_to_item(inst, item)
	shop_offset = $ShopGrid.get_child(6).position
	inst.global_position = shop_offset
	items_to_spawn.append(inst)
	
	item = items2x3.pick_random()
	inst = item.inventory.instantiate()
	pass_metadata_to_item(inst, item)
	shop_offset = $ShopGrid.get_child(3).position
	inst.global_position = shop_offset
	items_to_spawn.append(inst)
	
	items_to_spawn.shuffle()
	
	for i in snappedf(randf_range(spawn_count.x,spawn_count.y),1.0):
		items_to_spawn.pop_front()
	
	Signals.emit_signal("spawn_inventory_items",items_to_spawn)
	

func leveling_up(value:bool):
	lvling_up = value
	player_level += 1.0
	if value:
		match player_level:
			3.0: spawn_count = Vector2(7,8)
			4.0: spawn_count = Vector2(6,7)
			5.0: spawn_count = Vector2(5,6)
			6.0: spawn_count = Vector2(4,6)
			7.0: spawn_count = Vector2(3,6)
			10.0: spawn_count = Vector2(1,4)
			
		$CPUParticles2D.emitting = true
		$AnimationPlayer.play("stretch")
		$CPUParticles2D2.emitting = true
		visible = true
		$ShopGridBG.play("open")
		for child in $ShopGrid.get_children():
			child.get_child(0).set_deferred("monitorable",true)
		open_shop()
	else:
		$CloseGapSign.visible = false
		visible = false
		$CPUParticles2D.emitting = false
		for child in $ShopGrid.get_children():
			child.get_child(0).set_deferred("monitorable",false)
		


func pass_metadata_to_item(inst, item):
	inst.current_item = item.item_name
	inst.item_name = item.name[item.item_name]
	inst.item_description = item.description
	inst.item_description_2 = item.description_2
	inst.scene = item.spawnable
	inst.icon = item.icon
	inst.active = item.active
	inst.item_cooldown = item.cooldown
	inst.one_time_spawn = item.one_time_spawn
	if item.item_set != null:
		inst.item_set = item.item_set
	if item.spell_card != null:
		inst.spell_card = item.spell_card.spawnable
		inst.spell_card_icon = item.spell_card.icon
		inst.spell_card_cooldown = item.spell_card.cooldown

func _process(delta):
	eyes_scrolling -= delta * 8
	$ShopGridBG/mask/eyes.region_rect = Rect2(eyes_scrolling,eyes_scrolling,400,400)
	$ShopGridBG/mask/eyes.rotation += delta / 30
	if lvling_up:
		if Input.is_action_just_pressed("cancel") and !$close_gap.disabled:
			close_gap()

func show_close_sign():
	if !rerolling:
		$CloseGapSign.visible = false
		$CloseGapSign.play("default")

func close_gap():
	$reroll_gap.disabled = true
	$close_gap.disabled = true
	Globals.holding_item = false
#	Signals.hide_hand_cursor.emit()
	Signals.emit_signal("show_hand_cursor",false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CloseGapSign.material.set_shader_parameter("line_color",Color(0,0,0,1))
	Signals.emit_signal("leveling_up",false)
	Globals.leveling_up = false

func _on_close_gap_sign_animation_finished():
	if $CloseGapSign.frame == 0:
		$CloseGapSign.visible = false
		rerolling = true
		$AnimationPlayer.play_backwards("stretch")
		await get_tree().create_timer(1.0).timeout
		open_shop()
		$CPUParticles2D.emitting = true
		$AnimationPlayer.play("stretch")
		$CPUParticles2D2.emitting = true
	else:
		can_reroll = true
		$reroll_gap.disabled = false
		$close_gap.disabled = false

func _on_reroll_button_down():
	if can_reroll:
		if Globals.crystal_count > 0:
			$Reroll.visible = false
			$CloseGap.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Signals.emit_signal("show_right_click_tip",false)
			Signals.emit_signal("reroll_gap")
			$CloseGapSign.play_backwards("default")
			Globals.crystal_count -= 1.0
			Signals.emit_signal("decrease_crystal_count")
			can_reroll = false
		else:
			Signals.emit_signal("not_enough_crystals")

func play_open_sfx():
	Signals.emit_signal("gap_open_sfx")

func _on_close_gap_button_up():
	close_gap()

func _on_reroll_gap_button_up():
	if can_reroll:
		if Globals.crystal_count > 0:
			$reroll_gap.disabled = true
			$close_gap.disabled = true
			Signals.emit_signal("reroll_gap")
			$CloseGapSign.play_backwards("default")
			Globals.crystal_count -= 1.0
			Signals.emit_signal("decrease_crystal_count")
			can_reroll = false
		else:
			Signals.emit_signal("not_enough_crystals")

func _on_close_gap_mouse_entered():
	Signals.emit_signal("show_hand_cursor",true)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$CloseGapSign.material.set_shader_parameter("line_color",Color(1,1,1,1))

func _on_close_gap_mouse_exited():
	Signals.emit_signal("show_hand_cursor",false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CloseGapSign.material.set_shader_parameter("line_color",Color(0,0,0,1))

func _on_reroll_gap_mouse_entered():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Signals.emit_signal("show_hand_cursor",true)

func _on_reroll_gap_mouse_exited():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Signals.emit_signal("show_hand_cursor",false)
