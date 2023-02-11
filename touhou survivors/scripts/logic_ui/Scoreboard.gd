extends Node

var power:float:
	set(value):
		power = value
		check_for_lvl_up()
		Signals.emit_signal("current_power",power)

var next_lvl:float = 2.0:
	set(value):
		next_lvl = value
		Signals.emit_signal("next_lvl_update",next_lvl)

@export var next_lvl_increase_rate:float = 1.5
@export var occult_orb_max:float = 10.0

func _ready():
	Signals.connect("update_power",catch_update_power)
	

func catch_update_power(update):
	power += update

func check_for_lvl_up():
	if power >= next_lvl:
		Signals.emit_signal("leveling_up",true)
		power = power - next_lvl
		next_lvl *= next_lvl_increase_rate

func _on_threat_timeout():
	Signals.emit_signal("increase_threat")
