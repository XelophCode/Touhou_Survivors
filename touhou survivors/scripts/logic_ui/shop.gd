extends Node2D

enum {_1x1,_1x2,_1x3,_2x2,_2x3}
var eyes_scrolling : float

@export var inv_items : all_items

func _ready():
	Signals.connect("leveling_up",leveling_up)

func open_shop():
	
#	global_position.x = Globals.player_position.x - 100
#	global_position.y = Globals.player_position.y
	
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
	
	for i in randi_range(0,4):
		items_to_spawn.pop_front()
	
	Signals.emit_signal("spawn_inventory_items",items_to_spawn)
	
#	for items in items_to_spawn:
#		items.position += Globals.player_position + Vector2(-100,0)
#		get_parent().get_node("PlayerInventory").call_deferred("add_child",items)

func leveling_up(value:bool):
	if value:
		$CPUParticles2D.emitting = true
		$AnimationPlayer.play("stretch")
		$CPUParticles2D2.emitting = true
		visible = true
		$ShopGridBG.play("open")
		for child in $ShopGrid.get_children():
			child.get_child(0).set_deferred("monitorable",true)
		open_shop()
	else:
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

func _process(delta):
	eyes_scrolling -= delta * 8
	$ShopGridBG/mask/eyes.region_rect = Rect2(eyes_scrolling,eyes_scrolling,400,400)
	$ShopGridBG/mask/eyes.rotation += delta / 30
