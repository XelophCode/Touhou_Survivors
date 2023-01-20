extends Node2D

@onready var parent = get_parent()
@export_enum("1x1","1x2","1x3","2x2","2x3") var offset_setting
var show_highlight:bool = false

func _ready():
	parent.offset_setting = offset_setting

func _on_click_and_inventory_input_event(_viewport, event, _shape_idx):
	parent.click_detection(event)

func _on_click_and_inventory_mouse_entered():
	parent.show_tooltip()

func _on_click_and_inventory_mouse_exited():
	parent.hide_tooltip()

func _on_click_and_inventory_area_entered(_area):
	parent.in_inventory = true

func _on_click_and_inventory_area_exited(_area):
	parent.in_inventory = false

func _on_main_placement_area_entered(area):
	parent.current_area_hovered = area
	parent.slot_position_hovering = area.global_position + parent.rotational_offset
	parent.slots_currently_hovering += 1

func _on_main_placement_area_exited(_area):
	parent.slots_currently_hovering -= 1

func _on_additional_placement_area_entered(_area):
	parent.slots_currently_hovering += 1

func _on_additional_placement_area_exited(_area):
	parent.slots_currently_hovering -= 1

func _on_occupied_and_stack_area_entered(area):
	parent.occupied_and_stack_entered(area)

func _on_occupied_and_stack_area_exited(area):
	parent.occupied_and_stack_exited(area)
