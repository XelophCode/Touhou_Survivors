extends Node2D

func _ready():
	Signals.connect("spawn_inventory_items",catch_spawn_inventory_items)
	

func catch_spawn_inventory_items(items:Array):
	for item in items:
		item.position.x += 115
		item.position.y += 125
		call_deferred("add_child",item)
