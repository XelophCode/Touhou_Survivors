extends Node

var faith:float:
	set(value):
		faith = value
		Signals.emit_signal("current_faith",faith)

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

func _ready():
	Signals.connect("update_power",catch_update_power)
	Signals.connect("update_faith",catch_update_faith)
	Signals.connect("leveling_up",catch_leveling_up)

func catch_update_faith(update):
	faith += update

func catch_update_power(update):
	power += update

func check_for_lvl_up():
	if power >= next_lvl:
		Signals.emit_signal("leveling_up",true)
		power = power - next_lvl
		next_lvl *= next_lvl_increase_rate

func _on_threat_timeout():
	Signals.emit_signal("increase_threat")

func catch_leveling_up(value):
	if value:
		$Threat.paused = true
	else:
		$Threat.paused = false
