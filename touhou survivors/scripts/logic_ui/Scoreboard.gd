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

var crystal:float:
	set(value):
		crystal = value
		Signals.emit_signal("current_crystal",crystal)

var next_lvl:float = 5.0:
	set(value):
		next_lvl = value
		Signals.emit_signal("next_lvl_update",next_lvl)

var player_level:float = 1.0

@export var next_lvl_increase_rate:float = 2.0

func _ready():
	Globals.rand_id_assigns = []
	Signals.connect("update_power",catch_update_power)
	Signals.connect("update_faith",catch_update_faith)
	Signals.connect("leveling_up",catch_leveling_up)
	Signals.connect("update_crystal",catch_update_crystal)

func catch_update_faith(update):
	faith += update

func catch_update_power(update):
	power += update

func check_for_lvl_up():
	if power >= next_lvl:
		player_level += 1.0
		Signals.emit_signal("leveling_up",true)
		power = power - next_lvl
		
		match player_level:
			4.0: next_lvl_increase_rate = 1.8
			7.0: next_lvl_increase_rate = 1.6
			9.0: next_lvl_increase_rate = 1.4
			11.0: next_lvl_increase_rate = 1.2
			15.0: next_lvl_increase_rate = 1.1
		
		next_lvl *= next_lvl_increase_rate

func _on_threat_timeout():
	Signals.emit_signal("increase_threat")

func catch_leveling_up(value):
	if value:
		$Threat.paused = true
	else:
		$Threat.paused = false

func catch_update_crystal(value):
	crystal += value
	
