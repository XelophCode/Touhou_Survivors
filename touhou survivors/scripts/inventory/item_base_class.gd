extends Node2D
class_name item_base_class

@onready var damage_popup = preload("res://prefabs/logic_ui/damage_popup.tscn")
var damage:int = 0
var stack_count:int = 1

func do_damage(body):
	body.hp -= damage
	body.knockback = true
	var inst = damage_popup.instantiate()
	inst.value = damage
	inst.pos = body.global_position
	get_parent().add_child(inst)
