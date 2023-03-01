extends item_base_class

func _ready():
	if alt_fire:
		Signals.emit_signal("modify_player_speed","initialize",2.0)
	else:
		Signals.emit_signal("modify_player_speed","initialize",1.3)

func _on_tree_exiting():
	Signals.emit_signal("modify_player_speed","remove")

func update(alt_fire_update:bool):
	if alt_fire_update:
		Signals.emit_signal("modify_player_speed","modify",2.0)
	else:
		Signals.emit_signal("modify_player_speed","modify",1.3)
