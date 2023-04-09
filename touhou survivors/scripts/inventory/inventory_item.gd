extends Node2D

var item_name:String = ""
var current_item

var item_description:String = ""
var initial_cooldown:int = 10
var stack_count_max:int = 5

var scene : PackedScene
var icon : Texture

@onready var item_large_bg = $ItemLargeBg

var do_stretch_anim:bool = true
var show_highlight:bool = false
var active:bool
var offset_setting:int
var left_mouse_button_held:bool = false
var right_mouse_button_held:bool = false
var player_last_position:Vector2
var player_last_current_position_difference:Vector2
var new_position:Vector2
var slot_position_hovering:Vector2
var slot_count:int
var slots_currently_hovering:int
var new_rotation:float
var hovering_occupied_space:int
var old_stack_count:float = 1
var in_inventory:bool = false
var rotational_offset:Vector2
var item_cooldown:float = 1
var spawn_offset:Vector2
var saved_item:bool = false
var passive_limit:bool = false
var current_area_hovered
var one_time_spawn:bool
var occult_orb:bool = false
var orb_count:int
var area_awaiting_camera_still
var highlight_area_delay:Array
var rotated:bool = false
var previous_rotated:bool = false
var currently_in_weapons:bool = false
var adjacent_items:Array
var item_set:Array
var set_matches:Dictionary
var current_match:Array
var currently_in_set:bool = false
var set_selection:int
var spell_card_id:int = -1
var spell_card_color:Color
var spell_card
var spell_card_cooldown
var spell_card_icon
var found_new_position:bool = false

func find_rotational_offset():
	var rot:int = round(rad_to_deg(rotation))
	match offset_setting:
		0: rotational_offset = Vector2(0,0)
		1: match rot:
			0: rotational_offset = Vector2(0,11)
			90: rotational_offset = Vector2(-11,0)
			180: rotational_offset = Vector2(0,-11)
			270: rotational_offset = Vector2(11,0)
		2: match rot:
			0: rotational_offset = Vector2(0,22)
			90: rotational_offset = Vector2(-22,0)
			180: rotational_offset = Vector2(0,-22)
			270: rotational_offset = Vector2(22,0)
		3: match rot:
			0: rotational_offset = Vector2(11,11)
			90: rotational_offset = Vector2(-11,11)
			180: rotational_offset = Vector2(-11,-11)
			270: rotational_offset = Vector2(11,-11)
		4: match rot:
			0: rotational_offset = Vector2(11,22)
			90: rotational_offset = Vector2(-22,11)
			180: rotational_offset = Vector2(-11,-22)
			270: rotational_offset = Vector2(22,-11)

func leveling_up(value:bool):
	highlight_area_delay = []
	if value:
		$ItemSprite.scale.y = 0
		show_highlight = false
		$ItemLargeBg.visible = false
		pop_in_animation()
		if saved_item:
			visible = true
			new_position = current_area_hovered.global_position + rotational_offset
	else:
		visible = false
		if !in_inventory:
			queue_free()
		else:
			saved_item = true

func anim_show_highlight():
	show_highlight = true

func pop_in_animation():
	await get_tree().create_timer(randf_range(0.3,1.2)).timeout
	$ItemSprite.visible = true
	$AnimationPlayer.play("Inventory_Items/sprite_stretch")
	await get_tree().create_timer(0.01).timeout
	$ItemLargeBg.visible = true
	for i in highlight_area_delay:
		i.get_child(0).visible = true

func catch_update_orb_count(value):
	orb_count = value


func _ready():
	if do_stretch_anim:
		show_highlight = false
		pop_in_animation()
	else:
		show_highlight = true
	Signals.connect("leveling_up",leveling_up)
	Signals.connect("update_orb_count",catch_update_orb_count)
	Signals.connect("reroll_gap",catch_reroll_gap)
	Signals.connect("check_matching_sets",catch_check_matching_sets)
	find_rotational_offset()
	spawn_offset = get_child(0).get_node("main_placement").position * -1
	global_position += spawn_offset + rotational_offset
	new_position = position
	slot_position_hovering = position
	slot_count = get_child(0).get_node("additional_placement").get_child_count() + get_child(0).get_node("main_placement").get_child_count()

func _process(_delta):
	if left_mouse_button_held:
		if Input.is_action_just_released("left_mouse_button"):
			not_holding_item()
	if left_mouse_button_held:
		$ItemLargeBg.visible = false
		global_position = get_global_mouse_position()
		if Input.is_action_just_pressed("rotate_item"):
			Signals.emit_signal("rotate_sfx")
			rotated = !rotated
			rotation += deg_to_rad(90)
			if round(rad_to_deg(rotation)) >= 360:
				rotation = 0
			find_rotational_offset()
	else:
		find_rotational_offset()
		global_position = new_position
		rotation = new_rotation
		if show_highlight:
			$ItemLargeBg.visible = true

func click_detection(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse_button"):
			holding_item()
		if event.is_action_pressed("right_mouse_button"):
			if set_matches.size() > 1:
				for i in current_match:
					i.current_match = []
					i.set_matches = {}
					i.currently_in_set = false
					i.item_large_bg.material.set_shader_parameter("line_scale",0.0)
					i.spell_card_id = -1
				
				set_selection += 1
				if set_selection >= set_matches.size():
					set_selection = 0
					current_match = set_matches[set_selection]
				else:
					current_match = set_matches[set_selection]
				if current_match.size() > 0:
					for i in current_match:
						i.current_match = []
						i.spell_card_id = spell_card_id
						i.spell_card_color = spell_card_color
						i.current_match.append(self)
						for c in current_match:
							if c != i:
								i.current_match.append(c)
						i.get_other_item_matches()

func holding_item():
	Signals.emit_signal("item_grab_sfx")
	Signals.emit_signal("holding_item",true)
	$ItemHighlight.visible = false
	set_selection = 0
	if current_match.size() > 0:
		Signals.emit_signal("remove_weapon",spell_card_id,true)
		for i in current_match:
			i.current_match = []
			i.set_matches = {}
			i.item_large_bg.material.set_shader_parameter("line_scale",0.0)
			i.currently_in_set = false
			i.spell_card_id = -1
		current_match = []
		set_matches = {}
		item_large_bg.material.set_shader_parameter("line_scale",0.0)
		currently_in_set = false
		spell_card_id = -1
	Globals.holding_item = true
	Signals.emit_signal("hide_tooltip")
	find_rotational_offset()
	left_mouse_button_held = true
	z_index += 50

func not_holding_item():
	Signals.emit_signal("item_place_sfx")
	Signals.emit_signal("holding_item",false)
	$ItemHighlight.visible = true
	Globals.holding_item = false
	Signals.emit_signal("show_tooltip")
	
	Signals.emit_signal("show_hand_cursor",true)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	left_mouse_button_held = false
	z_index -= 50
	if slots_currently_hovering == slot_count and hovering_occupied_space == 0:
		found_new_position = true
		new_position = slot_position_hovering
		new_rotation = rotation
		
		if in_inventory:
			Signals.emit_signal("check_matching_sets")
			if currently_in_weapons and rotated != previous_rotated:
				Signals.emit_signal("modify_weapon",scene,get_instance_id(),rotated)
			Signals.emit_signal("add_weapon",scene,get_instance_id(),item_cooldown,active,icon,rotated)
			currently_in_weapons = true
			if one_time_spawn:
				Globals.one_time_spawns.append(item_name)
		else:
			Signals.emit_signal("remove_weapon",get_instance_id(),active)
			currently_in_weapons = false
			if one_time_spawn:
				Globals.one_time_spawns.erase(item_name)
		previous_rotated = rotated
	else:
		rotated = previous_rotated
	
	
	
	if in_inventory and !currently_in_set and found_new_position:
		check_for_item_set()
	
	found_new_position = false


func check_for_item_set():
	if adjacent_items.size() > 1:
		find_matches()
		if current_match.size() > 0:
			for i in current_match:
				i.current_match = []
				i.spell_card_id = spell_card_id
				i.spell_card_color = spell_card_color
				i.current_match.append(self)
				for c in current_match:
					if c != i:
						i.current_match.append(c)
				i.get_other_item_matches()

func find_matches(autofill_set_0:bool = false):
	var matching_items_1:Array = []
	var matching_items_2:Array = []
	var matching_items_1_value:int = -1
	var matching_items_2_value:int = -1
	for i in adjacent_items:
		if item_set.has(i.current_item) and !i.currently_in_set:
			if matching_items_1_value == -1:
				matching_items_1_value = i.current_item
				matching_items_1.append(i)
			elif matching_items_2_value == -1 and i.current_item != matching_items_1_value and !i.currently_in_set:
				matching_items_2_value = i.current_item
				matching_items_2.append(i)
			else:
				if !i.currently_in_set:
					match i.current_item:
						matching_items_1_value: matching_items_1.append(i)
						matching_items_2_value: matching_items_2.append(i)
	
	if matching_items_1.size() > 0 and matching_items_2.size() > 0:
		set_matches = {}
		var match_val:int = 0
		var matches:Array
		if autofill_set_0:
			set_matches[0] = current_match
			match_val += 1
		for m in matching_items_1:
			for a in m.adjacent_items:
				if matching_items_2.has(a):
					matches.append(m)
					matches.append(a)
					if autofill_set_0:
						if !(current_match.has(matches[0]) and current_match.has(matches[1])):
							set_matches[match_val] = matches
					else:
						set_matches[match_val] = matches
						match_val += 1
					matches = []
	if set_matches != {}:
		if !autofill_set_0:
			var rand_id:int = randi_range(1,10000)
			while Globals.rand_id_assigns.has(rand_id):
				rand_id = randi_range(1,10000)
			Globals.rand_id_assigns.append(rand_id)
			spell_card_id = rand_id
			spell_card_color = Globals.random_color()
			Signals.emit_signal("add_weapon",spell_card,spell_card_id,spell_card_cooldown,true,spell_card_icon,false,false,spell_card_color)
		current_match = set_matches[0]
		$ItemLargeBg.material.set_shader_parameter("line_scale",1.0)
		$ItemLargeBg.material.set_shader_parameter("line_color",spell_card_color)
		currently_in_set = true

func get_other_item_matches():
	set_matches[0] = current_match
	find_matches(true)

func occupied_and_stack_exited(area):
	if area.collision_layer == 64:
		hovering_occupied_space -= 1
	if area.collision_layer == 32 and show_highlight:
		area.get_child(0).visible = false

func occupied_and_stack_entered(area):
	if area.collision_layer == 64:
		hovering_occupied_space += 1
	if area.collision_layer == 32 and show_highlight:
		area.get_child(0).visible = true
	if !show_highlight:
		highlight_area_delay.append(area)

func hide_tooltip():
	$ItemHighlight.visible = false
	Signals.emit_signal("show_hand_cursor",false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if in_inventory:
		Signals.emit_signal("show_icon_highlight",get_instance_id(),false)
		if set_matches.size() > 1:
			Signals.emit_signal("show_spell_card_right_click",false)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Globals.tooltip_info.erase([item_name,item_description])
	if Globals.tooltip_info == []:
		Signals.emit_signal("hide_tooltip")

func show_tooltip():
	$ItemHighlight.visible = true
	Signals.emit_signal("show_hand_cursor",true)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if in_inventory:
		Signals.emit_signal("show_icon_highlight",get_instance_id(),true)
		if set_matches.size() > 1:
			Signals.emit_signal("show_spell_card_right_click",true)
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Globals.tooltip_info.push_front([item_name,item_description])
	if !left_mouse_button_held:
		Signals.emit_signal("show_tooltip")

func catch_reroll_gap():
	if !in_inventory:
		$ItemLargeBg.visible = false
		$AnimationPlayer.play_backwards("Inventory_Items/sprite_stretch")
		await get_tree().create_timer(0.75).timeout
		$ItemSprite.visible = false
		queue_free()

func catch_check_matching_sets():
	if currently_in_set:
		set_matches = {}
		
		var matching_items_1:Array = []
		var matching_items_2:Array = []
		var matching_items_1_value:int = -1
		var matching_items_2_value:int = -1
		for i in adjacent_items:
			if item_set.has(i.current_item):
				if matching_items_1_value == -1:
					matching_items_1_value = i.current_item
					matching_items_1.append(i)
				elif matching_items_2_value == -1 and i.current_item != matching_items_1_value:
					matching_items_2_value = i.current_item
					matching_items_2.append(i)
				else:
					match i.current_item:
						matching_items_1_value: matching_items_1.append(i)
						matching_items_2_value: matching_items_2.append(i)
		
		if matching_items_1.size() > 0 and matching_items_2.size() > 0:
			set_matches = {}
			var match_val:int = 0
			var matches:Array
			for m in matching_items_1:
				for a in m.adjacent_items:
					if matching_items_2.has(a):
						matches.append(m)
						matches.append(a)
						set_matches[match_val] = matches
						match_val += 1
						matches = []
