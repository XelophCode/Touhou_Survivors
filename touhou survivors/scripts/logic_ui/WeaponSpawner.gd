extends Node2D

var icon_instances:Dictionary
var timer_instances:Dictionary
var items_in_inventory:Array
var inventory_item_ids:Array
var passive_item_ids:Dictionary
var spell_card_icons:Array = ["res://sprites/items/item_icons/fantasy_seal_icon.png","res://sprites/items/item_icons/grimoire_of_alice_icon.png","res://sprites/items/item_icons/invisible_full_moon_icon.png","res://sprites/items/item_icons/master_spark_icon.png","res://sprites/items/item_icons/peerless_wind_god_icon.png"]
var current_spellcards:Array

func _ready():
	Signals.connect("add_weapon",add_weapon)
	Signals.connect("remove_weapon",remove_weapon)
	Signals.connect("modify_weapon",modify_weapon)
	Signals.connect("leveling_up",leveling_up)
	Signals.connect("show_icon_highlight",catch_show_icon_highlight)
	Signals.connect("stop_weapons",catch_stop_weapons)
	var loaded_save = Appdata.load_file(Appdata.SAVE)
	Globals.used_items = loaded_save.ITEM_NAMES
	Globals.used_items_total = loaded_save.ITEMS_USED
	Globals.used_spellcards = loaded_save.SPELLCARD_NAMES
	Globals.used_spellcards_total = loaded_save.SPELLCARDS_USED
	Globals.simul_spellcard = 0
	Globals.all_spellcard = loaded_save.ALL_SPELLCARDS


func _process(_delta):
	var counter = 0
	if $icon_instances.get_child_count() != 0:
		for icon in $icon_instances.get_children():
			icon.position = $icon_positions.get_child(counter).position
			counter += 1

func add_weapon(scene:PackedScene,inventory_item_id:int,cooldown:float,active:bool,icon:Texture,rotated:bool,autostart:bool = false,icon_color:Color = Color(1,1,1,1)):
	if !inventory_item_ids.has(inventory_item_id):
		if active:
			
			if !spell_card_icons.has(str(icon.resource_path)):
				if !Globals.used_items.has(str(icon.resource_path)):
					Globals.used_items.append(str(icon.resource_path))
					Globals.used_items_total += 1
			else:
				if !Globals.used_spellcards.has(str(icon.resource_path)):
					Globals.used_spellcards.append(str(icon.resource_path))
					Globals.used_spellcards_total += 1
				current_spellcards.append(inventory_item_id)
				Globals.simul_spellcard += 1
				print(str(Globals.simul_spellcard))
				if Globals.simul_spellcard == 5:
					print("all spells achieved")
					Globals.all_spellcard = true
					
			
			inventory_item_ids.append(inventory_item_id)
			var timer_new = Timer.new()
			timer_new.wait_time = cooldown
			timer_new.autostart = autostart
			timer_new.connect("timeout",spawn_weapon.bind(scene,rotated))
			timer_instances[inventory_item_id] = timer_new.get_instance_id()
			get_node("timer_instances").add_child(timer_new)
			var icon_inst = $icon_base.duplicate()
			icon_inst.get_child(0).timer_id = timer_new.get_instance_id()
			icon_inst.get_child(0).visible = true
			icon_inst.get_child(1).modulate = icon_color
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
			scene_inst.alt_fire = rotated
			Signals.emit_signal("weapon_add_child",scene_inst)

func spawn_weapon(item,rotated:bool = false):
	var new_weapon_inst = item.instantiate()
	new_weapon_inst.alt_fire = rotated
	Signals.emit_signal("weapon_add_child",new_weapon_inst)
	

func remove_weapon(inventory_item_id:int,active):
	if inventory_item_ids != []:
		if inventory_item_ids.has(inventory_item_id):
			if current_spellcards.has(inventory_item_id):
				current_spellcards.erase(inventory_item_id)
				Globals.simul_spellcard -= 1
				print(str(Globals.simul_spellcard))
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

func modify_weapon(scene:PackedScene,inventory_item_id:int,rotated:bool):
	if timer_instances != {}:
		if timer_instances.has(inventory_item_id):
			var inst_id:int = timer_instances[inventory_item_id]
			var inst := instance_from_id(inst_id)
			inst.disconnect("timeout",spawn_weapon)
			inst.connect("timeout",spawn_weapon.bind(scene,rotated))
	if passive_item_ids.has(inventory_item_id):
		instance_from_id(passive_item_ids[inventory_item_id]).update(rotated)

func leveling_up(value:bool):
	if value:
		for timer in $timer_instances.get_children():
			timer.paused = true
	else:
		for timer in $timer_instances.get_children():
			if timer.paused == false:
				timer.start()
			timer.paused = false

func catch_show_icon_highlight(inventory_item_id:int, show_highlight:bool):
	if icon_instances.has(inventory_item_id):
		if show_highlight:
			instance_from_id(icon_instances[inventory_item_id]).get_child(2).visible = true
		else:
			instance_from_id(icon_instances[inventory_item_id]).get_child(2).visible = false

func catch_stop_weapons():
	for timer in $timer_instances.get_children():
		timer.paused = true
