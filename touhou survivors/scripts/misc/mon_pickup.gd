extends Node2D

@export var sprite:AnimatedSprite2D
var move_towards_player:bool = false
var leveling_up:bool = false
var move:Vector2

func _ready():
	if Globals.leveling_up:
		$Timer.paused = true
	Signals.connect("leveling_up",catch_leveling_up)
	$main_body.position += Vector2(randf_range(-5,5),randf_range(-5,5))

func _process(delta):
	if move_towards_player and !leveling_up:
		move = lerp(move,$main_body/main_body_2.global_position.direction_to(Globals.player_position)*2,delta*3)
	else:
		move = Vector2.ZERO
	$main_body/main_body_2.translate(move)

func catch_leveling_up(value):
	leveling_up = value
	if leveling_up:
		if !$Timer.is_stopped():
			$Timer.paused = true
		if $FlickerAnim.is_playing():
			$FlickerAnim.pause()
	else:
		if $Timer.paused == true:
			$Timer.paused = false
		else:
			$FlickerAnim.play()

func _on_area_2d_body_entered(_body):
	Signals.emit_signal("increase_mon")
	queue_free()

func _on_timer_timeout():
	$FlickerAnim.play("flicker")
