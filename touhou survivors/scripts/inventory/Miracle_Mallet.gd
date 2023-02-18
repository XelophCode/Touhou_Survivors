extends item_base_class

func _ready():
	if occult_orb:
		Signals.emit_signal("modify_player_scale","initialize",2.0,4.0,0.25)
	else:
		Signals.emit_signal("modify_player_scale","initialize",1.5,2.0,0.5)

func _on_tree_exiting():
	Signals.emit_signal("modify_player_scale","remove",1.0,0.5,1.0)

func update():
	Signals.emit_signal("modify_player_scale","modify",2.0,4.0,0.25)
