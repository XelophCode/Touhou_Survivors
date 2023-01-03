extends Node2D

func _ready():
	Signals.connect("leveling_up",leveling_up)
	$InventoryAnimation.play("default")

func leveling_up(value:bool):
	if !value:
		visible = false
		for area in $InventoryGrid.get_children():
			var space = area.get_child(0)
			space.monitorable = false

func _on_inventory_animation_animation_finished():
	$InventoryAnimation.playing = false
	$InventoryAnimation.frame = 5

func open_inventory():
	$AnimationPlayer.play("slide")
	visible = true
	$InventoryAnimation.frame = 0
	$InventoryAnimation.play("default")
	for area in $InventoryGrid.get_children():
		var space = area.get_child(0)
		space.monitorable = true
