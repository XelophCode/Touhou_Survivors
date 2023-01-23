extends Node2D

var item_name:String = ""
var current_item

var item_description:String = ""
var initial_cooldown:int = 10
var stack_count_max:int = 5


var scene : PackedScene
var icon : Texture

@onready var occult_orb_progress = $occult_orb/occult_orb_progress
@onready var occult_orb_shimmer = $occult_orb/shimmer

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
var stack:int
var stack_count:int = 1
var old_stack_count:float = 1
var stacked_object:Array
var in_inventory:bool = false
var rotational_offset:Vector2
var item_cooldown:float = 1
var spawn_offset:Vector2
var saved_item:bool = false
var previous_stack_target
var passive_limit:bool = false
var current_area_hovered
var one_time_spawn:bool

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
	if value:
		$ItemSprite.scale.y = 0
		$occult_orb.scale.y = 0
		show_highlight = false
		$ItemLargeBg.visible = false
		pop_in_animation()
		if saved_item:
			await get_tree().create_timer(0.1).timeout
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
	$ItemSprite.material.set_shader_parameter("flash_modifier",1.0)
	await get_tree().create_timer(0.01).timeout
	$ItemLargeBg.visible = true

func _ready():
	if do_stretch_anim:
		show_highlight = false
		pop_in_animation()
	else:
		show_highlight = true
	Signals.connect("leveling_up",leveling_up)
	find_rotational_offset()
	spawn_offset = get_child(0).get_node("main_placement").position * -1
	global_position += spawn_offset + rotational_offset
	new_position = position
	slot_position_hovering = position
	slot_count = get_child(0).get_node("additional_placement").get_child_count() + get_child(0).get_node("main_placement").get_child_count()
	occult_orb_progress.max_value = stack_count_max
	

func _physics_process(delta):
	if $ItemSprite.material.get_shader_parameter("flash_modifier") > 0:
		$ItemSprite.material.set_shader_parameter("flash_modifier",lerp($ItemSprite.material.get_shader_parameter("flash_modifier"),0.0,delta*3))
	if left_mouse_button_held:
		if Input.is_action_just_released("left_mouse_button"):
			not_holding_item()
		if right_mouse_button_held:
			if Input.is_action_just_released("right_mouse_button"):
				var overstacked:bool = true
				if stacked_object != []:
					if !(stacked_object[0].stack_count + stack_count > stack_count_max):
						overstacked = false
				if hovering_occupied_space > 1 or (hovering_occupied_space > 0 and overstacked):
					stacked_object = [previous_stack_target]
					stack = 1
					hovering_occupied_space = 1
				not_holding_item()
				right_mouse_button_held = false
	
	if stack_count == stack_count_max:
		occult_orb_shimmer.emitting = true
	else:
		occult_orb_shimmer.emitting = false
	occult_orb_progress.value = stack_count
	if stack_count != old_stack_count and in_inventory:
		Signals.emit_signal("modify_weapon",scene,get_instance_id(),item_cooldown,active,stack_count)
	old_stack_count = stack_count
	if left_mouse_button_held:
		$ItemLargeBg.visible = false
		global_position = get_global_mouse_position()
		if Input.is_action_just_pressed("rotate_item"):
			rotation += deg_to_rad(90)
			if round(rad_to_deg(rotation)) >= 360:
				rotation = 0
			find_rotational_offset()
	else:
		global_position = new_position
		rotation = new_rotation
		if show_highlight:
			$ItemLargeBg.visible = true

func click_detection(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse_button"):
			holding_item()
		if event.is_action_pressed("right_mouse_button") and !left_mouse_button_held and stack_count > 1:
			stack_count -= 1
			var new_stack_instance = self.duplicate()
			new_stack_instance.do_stretch_anim = false
			new_stack_instance.holding_item()
			new_stack_instance.right_mouse_button_held = true
			new_stack_instance.stack_count = 1
			new_stack_instance.previous_stack_target = instance_from_id(get_instance_id())
			new_stack_instance.scene = scene
			new_stack_instance.item_name = item_name
			new_stack_instance.stack_count_max = stack_count_max
			new_stack_instance.current_item = current_item
			new_stack_instance.active = active
			new_stack_instance.icon = icon
			new_stack_instance.item_cooldown = item_cooldown
			get_parent().add_child(new_stack_instance)

func holding_item():
	Signals.emit_signal("hide_tooltip")
	find_rotational_offset()
	left_mouse_button_held = true
	z_index += 50

func not_holding_item():
	Signals.emit_signal("show_tooltip",item_name,stack_count,stack_count_max,item_description)
	left_mouse_button_held = false
	z_index -= 50
	if slots_currently_hovering == slot_count and hovering_occupied_space == 0:
		new_position = slot_position_hovering
		new_rotation = rotation
		if in_inventory:
			Signals.emit_signal("add_weapon",scene,get_instance_id(),item_cooldown,active,icon,stack_count)
			if one_time_spawn:
				Globals.one_time_spawns.append(item_name)
		else:
			Signals.emit_signal("remove_weapon",get_instance_id(),active)
			if one_time_spawn:
				Globals.one_time_spawns.erase(item_name)
	if stack == 1 and hovering_occupied_space == 1 and (stacked_object[0].stack_count + stack_count <= stack_count_max):
		Signals.emit_signal("remove_weapon",get_instance_id(),active)
		stacked_object[0].stack_count += stack_count
		queue_free()
		stacked_object[0].show_stacked_tooltip()

func show_stacked_tooltip():
	Signals.emit_signal("show_tooltip",item_name,stack_count,stack_count_max,item_description)

func occupied_and_stack_exited(area):
	if area.collision_layer == 64:
		hovering_occupied_space -= 1
		if area.get_parent().get_parent().current_item == current_item:
			stacked_object.erase(area.get_parent().get_parent())
			stack -= 1
	if area.collision_layer == 32 and show_highlight:
		area.get_child(0).visible = false

func occupied_and_stack_entered(area):
	if area.collision_layer == 64:
		hovering_occupied_space += 1
		if area.get_parent().get_parent().current_item == current_item:
			stacked_object.append(area.get_parent().get_parent())
			stack += 1
	if area.collision_layer == 32 and show_highlight:
		area.get_child(0).visible = true

func hide_tooltip():
	Signals.emit_signal("hide_tooltip")

func show_tooltip():
	if !left_mouse_button_held:
		Signals.emit_signal("show_tooltip",item_name,stack_count,stack_count_max,item_description)