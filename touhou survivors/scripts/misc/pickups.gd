extends Node2D

var value:float = 1
var move_towards_player:bool = false
var move:Vector2
@export_enum("Power","Faith","Score") var Type
enum {POWER,FAITH,SCORE}
var rainbow_outline:bool = false
@export var sprite : Node
var leveling_up:bool = false

func _ready():
	Signals.connect("leveling_up",catch_leveling_up)
	if rainbow_outline:
		sprite.material.line_scale = 0.4
		sprite.material.rainbow = true
	else:
		sprite.material.line_scale = 0.0

func _process(delta):
	if move_towards_player and !leveling_up:
		move = lerp(move,global_position.direction_to(Globals.player_position)*2,delta*2)
	else:
		move = Vector2.ZERO
	translate(move)

func _on_area_2d_body_entered(_body):
	match Type:
		POWER: Signals.emit_signal("update_power", value)
		FAITH: Signals.emit_signal("update_faith", value)
		SCORE: pass
	queue_free()

func catch_leveling_up(value):
	leveling_up = value
