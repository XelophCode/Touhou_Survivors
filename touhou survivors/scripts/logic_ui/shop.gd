extends Node2D

enum {_1x1,_1x2,_1x3,_2x2,_2x3}

@export var inventory_items : FolderListResource

func _ready():
	Signals.connect("leveling_up",leveling_up)

func open_shop():
	await get_tree().create_timer(0.1).timeout
	$ShopGridBG.play("open")
	
	var items1x1:Array = []
	var items1x2:Array = []
	var items1x3:Array = []
	var items2x2:Array = []
	var items2x3:Array = []
	
	for item in inventory_items.all_resources:
		if !Globals.passive_items.has(item.name[item.item_name]) and item.enabled:
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
	
	for i in randi_range(0,4):
		items_to_spawn.pop_front()
	
	for items in items_to_spawn:
		items.position += Globals.player_position + Vector2(-100,0)
		
		get_parent().get_node("PlayerInventory").add_child(items)
	

func leveling_up(value:bool):
	if value:
		$AnimationPlayer.play("stretch")
		$CPUParticles2D2.emitting = true
		visible = true
		$ShopGridBG.playing = true
		$ShopGridBG.frame = 0
		for child in $ShopGrid.get_children():
			child.get_child(0).monitorable = true
	else:
		visible = false
		for child in $ShopGrid.get_children():
			child.get_child(0).monitorable = false


func _on_shop_grid_animation_finished():
	$ShopGridBG.playing = false
	$ShopGridBG.frame = 9

func pass_metadata_to_item(inst, item):
	inst.current_item = item.item_name
	inst.item_name = item.name[item.item_name]
	inst.item_description = item.description
	inst.scene = item.spawnable
	inst.icon = item.icon
	inst.active = item.active
	inst.item_cooldown = item.cooldown
	inst.stack_count_max = item.stack_limit
