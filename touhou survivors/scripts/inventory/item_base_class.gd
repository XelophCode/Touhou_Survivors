extends Node2D
class_name item_base_class

@onready var damage_popup = preload("res://prefabs/logic_ui/damage_popup.tscn")
var damage:int = 0
var alt_fire:bool = false

func do_damage(body):
	Signals.emit_signal("hit_sfx")
	body.hp -= damage + Globals.damage_bonus
	body.knockback = true
	var inst = damage_popup.instantiate()
	inst.value = damage + Globals.damage_bonus
	inst.pos = body.global_position
#	get_parent().add_child(inst)
	Signals.damage_popup_spawn.emit(inst)
