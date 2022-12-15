extends Node2D

var icon_instances:Dictionary
var timer_instances:Dictionary
var items_in_inventory:Array
var inventory_item_ids:Array
var passive_item_ids:Dictionary

func _ready():
	Signals.connect("add_weapon",add_weapon)
	Signals.connect("remove_weapon",remove_weapon)
	Signals.connect("modify_weapon",modify_weapon)
	Signals.connect("leveling_up",leveling_up)

func _process(_delta):
	var counter = 0
	if $icon_instances.get_child_count() != 0:
		for icon in $icon_instances.get_children():
			icon.position = $icon_positions.get_child(counter).position
			counter += 1

func add_weapon(scene:PackedScene,inventory_item_id:int,cooldown:float,active:bool,icon:Texture,stack_count:float,autostart:bool = false):
	if !inventory_item_ids.has(inventory_item_id):
		if active:
			inventory_item_ids.append(inventory_item_id)
			var timer_new = Timer.new()
			timer_new.wait_time = cooldown
			timer_new.autostart = autostart
			timer_new.connect("timeout",spawn_weapon.bind(scene,stack_count))
			timer_instances[inventory_item_id] = timer_new.get_instance_id()
			get_node("timer_instances").add_child(timer_new)
			var icon_inst = $icon_base.duplicate()
			icon_inst.get_child(0).timer_id = timer_new.get_instance_id()
			icon_inst.get_child(0).visible = true
			icon_inst.texture = icon
			icon_inst.visible = true
			icon_instances[inventory_item_id] = icon_inst.get_instance_id()
			$icon_instances.add_child(icon_inst)
		else:
			inventory_item_ids.append(inventory_item_id)
			var icon_inst = $icon_base.duplicate()
			icon_inst.visible = true
			icon_inst.texture = icon
			icon_instances[inventory_item_id] = icon_inst.get_instance_id()
			$icon_instances.add_child(icon_inst)
			var scene_inst = scene.instantiate()
			passive_item_ids[inventory_item_id] = scene_inst.get_instance_id()
			get_parent().get_parent().get_node("weapons").add_child(scene_inst)

func spawn_weapon(item,stack_count):
	var new_weapon_inst = item.instantiate()
	new_weapon_inst.stack_count = stack_count
	get_parent().get_parent().get_node("weapons").add_child(new_weapon_inst)

func remove_weapon(inventory_item_id:int,active):
	if inventory_item_ids != []:
		if inventory_item_ids.has(inventory_item_id):
			inventory_item_ids.erase(inventory_item_id)
			if active:
				var timer_inst_id:int = timer_instances[inventory_item_id]
				var timer_inst := instance_from_id(timer_inst_id)
				timer_inst.queue_free()
			else:
				if passive_item_ids.has(inventory_item_id):
					instance_from_id(passive_item_ids[inventory_item_id]).queue_free()
			var icon_inst_id:int = icon_instances[inventory_item_id]
			var icon_inst := instance_from_id(icon_inst_id)
			icon_inst.queue_free()
			timer_instances.erase(inventory_item_id)
			icon_instances.erase(inventory_item_id)

func modify_weapon(scene:PackedScene,inventory_item_id:int,cooldown:float,active:bool,stack_count:float):
	if timer_instances != {} and active:
		if timer_instances.has(inventory_item_id):
			var inst_id:int = timer_instances[inventory_item_id]
			var inst := instance_from_id(inst_id)
			inst.wait_time = cooldown + 0.0001
			inst.disconnect("timeout",spawn_weapon)
			inst.connect("timeout",spawn_weapon.bind(scene,stack_count))

func leveling_up(value:bool):
	if value:
		for timer in $timer_instances.get_children():
			timer.paused = true
	else:
		for timer in $timer_instances.get_children():
			if timer.paused == false:
				timer.start()
			timer.paused = false
