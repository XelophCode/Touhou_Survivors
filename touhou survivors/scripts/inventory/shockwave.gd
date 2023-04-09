extends item_base_class

func _ready():
	Signals.emit_signal("megaphone_blast_sfx")
	damage = randi_range(5,7)
	global_position = Globals.player_position

func _on_area_2d_body_entered(body):
	do_damage(body)
