extends Node2D

@export var bullet : PackedScene
@export_range(1,100,1.0) var bullet_count:float
@export_range(0.1,15.0,0.1) var initial_shoot_cooldown:float
@export_range(1.0,15.0,0.1) var shoot_cooldown:float
@export_range(0.01, 1.0,0.01) var shot_gap:float
var init_bullet_count:float
var leveling_up:bool = false
@export var aim_at_player:bool = false
@export_range(-100,100,1.0) var spiral_strength:float
@export_range(1,5,0.1) var frequency:float
@export_range(0,500,1.0) var amplitude:float
@export_range(1,10,0.1) var spin:float

func _ready():
	if initial_shoot_cooldown > 0:
		$Initialize.start(initial_shoot_cooldown)
	init_bullet_count = bullet_count
	Signals.connect("leveling_up",catch_leveling_up)

func _process(delta):
	if aim_at_player:
		look_at(Globals.player_position)
	elif spin > 1.0:
		rotation_degrees += delta * (spin*100)

func _on_initialize_timeout():
	$Loop.start(shot_gap)
	$Initialize.stop()

func _on_loop_timeout():
	if bullet_count > 0:
		var bullet_inst = bullet.instantiate()
		bullet_inst.global_position = global_position
		bullet_inst.rotation = rotation
		bullet_inst.spiral_strength = spiral_strength
		bullet_inst.frequency = frequency
		bullet_inst.amplitude = amplitude
		Signals.emit_signal("spawn_bullet",bullet_inst)
		bullet_count -= 1
	else:
		bullet_count = init_bullet_count
		$Loop.stop()
		$Initialize.start(shoot_cooldown)

func catch_leveling_up(value):
	leveling_up = value
	$Initialize.paused = value
	$Loop.paused = value
