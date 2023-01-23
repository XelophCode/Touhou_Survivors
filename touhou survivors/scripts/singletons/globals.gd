extends Node

enum {RIGHT = 1, LEFT = -1, DOWN = 1, UP = -1, CENTER = 0}

var player_position:Vector2
var player_facing:Vector2 = Vector2(0,1)
var leveling_up:bool = false
var power:float
var one_time_spawns:Array
var occult_orb_max : float = 10
var faith : float:
	set(value):
		faith = clamp(value,0,occult_orb_max * 5)
		Signals.emit_signal("update_faith")

func cardinal_direction_to_rotation(direction:Vector2):
	match direction:
		Vector2.RIGHT: return 0
		Vector2(RIGHT,UP): return -45
		Vector2.UP: return -90
		Vector2(LEFT,UP): return -135
		Vector2.LEFT: return -180
		Vector2(LEFT,DOWN): return -225
		Vector2.DOWN: return -270
		Vector2(DOWN,RIGHT): return -315
		Vector2.ZERO: return 0
