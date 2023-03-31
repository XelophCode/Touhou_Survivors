extends Node2D

@export var sprite:AnimatedSprite2D
var move_towards_player:bool = false
var leveling_up:bool = false
var move:Vector2

signal root_node

func _ready():
	sprite.frame = randi_range(0,8)
	emit_signal("root_node",self)
	Signals.connect("leveling_up",catch_leveling_up)
	init_tween()

func init_tween():
	var tween = create_tween()
	tween.tween_property($main_body/main_body_2,"position",Vector2(randf_range(-10,10),randf_range(-10,10)),0.6)

func _process(delta):
	if move_towards_player and !leveling_up:
		move = lerp(move,$main_body/main_body_2.global_position.direction_to(Globals.player_position)*2,delta*3)
	else:
		move = Vector2.ZERO
	$main_body/main_body_2.translate(move)

func catch_leveling_up(value):
	leveling_up = value

func _on_area_2d_body_entered(body):
	Signals.emit_signal("increase_mon")
	queue_free()

func _on_timer_timeout():
	queue_free()
