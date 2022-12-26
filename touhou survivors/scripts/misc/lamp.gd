extends Node2D

var health_pickup = preload("res://prefabs/misc/health_pickup.tscn")

func _on_area_2d_area_entered(_area):
	var health_inst = health_pickup.instantiate()
	health_inst.global_position = position
	health_inst.rotation = rotation
	get_parent().call_deferred("add_child",health_inst)
	queue_free()
