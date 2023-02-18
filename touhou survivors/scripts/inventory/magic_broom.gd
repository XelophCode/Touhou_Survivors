extends item_base_class

func _ready():
	if occult_orb:
		Signals.emit_signal("modify_player_speed","initialize",2.0)
	else:
		Signals.emit_signal("modify_player_speed","initialize",1.3)

func _on_tree_exiting():
	Signals.emit_signal("modify_player_speed","remove")

func update():
	Signals.emit_signal("modify_player_speed","modify",2.0)
