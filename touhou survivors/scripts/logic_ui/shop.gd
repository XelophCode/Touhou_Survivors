extends Node2D

enum {_1x1,_1x2,_1x3,_2x2,_2x3}
var eyes_scrolling : float

@export var inv_items : all_items
var rerolling:bool = false
var can_reroll:bool = false
var spawn_count:Vector2 = Vector2(0,1)
var player_level:float = 1.0

func _ready():
	Signals.connect("leveling_up",leveling_up)
	

func open_shop():
	rerolling = false
	var items1x1:Array = []
	var items1x2:Array = []
	var items1x3:Array = []
	var items2x2:Array = []
	var items2x3:Array = []
	
	for item in inv_items.items:
		if !Globals.one_time_spawns.has(item.name[item.item_name]) and item.enabled:
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
	
	for i in randi_range(spawn_count.x,spawn_count.y):
		items_to_spawn.pop_front()
	
	Signals.emit_signal("spawn_inventory_items",items_to_spawn)
	

func leveling_up(value:bool):
	player_level += 1.0
	if value:
		match player_level:
			3.0: spawn_count = Vector2(7,8)
			5.0: spawn_count = Vector2(5,7)
			10.0: spawn_count = Vector2(3,6)
			15.0: spawn_count = Vector2(1,4)
			
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

func show_close_sign():
	if !rerolling:
		$CloseGapSign.visible = true
		$CloseGapSign.play("default")

func _on_close_gap_button_down():
	Signals.emit_signal("show_hand_cursor",false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CloseGapSign.material.set_shader_parameter("line_color",Color(0,0,0,1))
	Signals.emit_signal("leveling_up",false)

func _on_close_gap_mouse_entered():
	Signals.emit_signal("show_hand_cursor",true)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$CloseGapSign.material.set_shader_parameter("line_color",Color(1,1,1,1))

func _on_close_gap_mouse_exited():
	Signals.emit_signal("show_hand_cursor",false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CloseGapSign.material.set_shader_parameter("line_color",Color(0,0,0,1))


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
		$Reroll.visible = true
		$CloseGap.visible = true

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


func _on_reroll_mouse_entered():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Signals.emit_signal("show_right_click_tip",true)

func _on_reroll_mouse_exited():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Signals.emit_signal("show_right_click_tip",false)
