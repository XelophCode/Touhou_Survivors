extends Node2D

var value:float = 1
var move_towards_player:bool = false
var move:Vector2

func _physics_process(delta):
	if move_towards_player and !Globals.leveling_up:
		move = lerp(move,global_position.direction_to(Globals.player_position)*2,delta*2)
	else:
		move = Vector2.ZERO
	translate(move)

func _on_area_2d_body_entered(_body):
	Signals.emit_signal("update_power", value)
	queue_free()


func _on_move_towards_player_body_entered(body):
	move_towards_player = true

func _on_move_towards_player_body_exited(body):
	move_towards_player = false
