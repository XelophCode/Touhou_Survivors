extends Node2D

@onready var parent = get_parent()
@export_enum("1x1","1x2","1x3","2x2","2x3") var offset_setting
var show_highlight:bool = false
var main_area

func toggle_set_detection():
	$set_detection.monitorable = false
	$set_detection.monitoring = false
	$set_detection.monitorable = true
	$set_detection.monitoring = true

func _ready():
	parent.offset_setting = offset_setting

func _on_click_and_inventory_mouse_exited():
	owner.can_show_preview = false
	owner.hide_tooltip()

func _on_click_and_inventory_mouse_entered():
	if !Input.is_action_pressed("left_mouse_button"):
		owner.can_show_preview = true
		parent.show_tooltip()

func _on_click_and_inventory_input_event(_viewport, event, _shape_idx):
	owner.click_detection(event)

func _on_click_and_inventory_area_entered(_area):
	parent.in_inventory = true

func _on_click_and_inventory_area_exited(_area):
	parent.in_inventory = false

func _on_main_placement_area_entered(area):
	parent.current_area_hovered = area
	main_area = area
	parent.slots_currently_hovering += 1
	calculate_slot_position_hovering()

func _on_main_placement_area_exited(_area):
	parent.slots_currently_hovering -= 1

func _on_additional_placement_area_entered(_area):
	parent.slots_currently_hovering += 1
	calculate_slot_position_hovering()

func _on_additional_placement_area_exited(_area):
	parent.slots_currently_hovering -= 1

func _on_occupied_and_stack_area_entered(area):
	parent.occupied_and_stack_entered(area)

func _on_occupied_and_stack_area_exited(area):
	parent.occupied_and_stack_exited(area)

func calculate_slot_position_hovering():
	if main_area != null:
		parent.slot_position_hovering = main_area.global_position + parent.rotational_offset
	else:
		parent.slot_position_hovering = Vector2.ZERO

func _on_set_detection_area_entered(area):
	parent.adjacent_items.append(area.owner.owner)

func _on_set_detection_area_exited(area):
	parent.adjacent_items.erase(area.owner.owner)
	parent.adjacent_items.erase(area.owner.owner)
