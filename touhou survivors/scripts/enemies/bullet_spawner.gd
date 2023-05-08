extends Node2D

const speed_range := Vector3(0.1,5,0.1)
const size_range := Vector3(1,3,0.1)


@export_group("Bullet Spawner")
@export var bullets:Array[PackedScene]
@export_range(speed_range.x,speed_range.y,speed_range.z) var speed:float = 1.0
@export_range(0,0.2,0.01) var speed_random:float = 0
@export_range(size_range.x,size_range.y,size_range.z) var size:float = 1.0
@export_range(0,0.2,0.01) var size_random:float = 0

@export_subgroup("Spawning")
@export var enabled:bool = false
@export var oneshot:bool = false
@export_range(1,100,1.0) var chance_to_shoot:float = 100.0
@export_range(1,100,1.0) var bullet_count:float = 1.0
@export_range(0,10,1.0) var bullet_count_random:float = 0

@export_subgroup("Cooldown")
@export_range(0.1,15.0,0.1) var initial_shoot_cooldown:float = 15.0
@export_range(1.0,15.0,0.1) var shoot_cooldown:float = 5.0
@export_range(0.01, 1.0,0.01) var shot_gap:float = 0.2

@export_subgroup("Direction")
@export var aim_at_player:bool = false
@export_range(0,90,1.0) var spread:float = 0
@export_range(-100,100,1.0) var spiral_strength:float = 0
@export_range(1,5,0.1) var frequency:float = 1.0
@export_range(0,500,1.0) var amplitude:float = 0
@export_range(1,10,0.1) var spin:float = 1.0

var init_bullet_count:float
var leveling_up:bool = false
var random_check_passed:bool = false
var amplitude_look_at_player:bool = true

func _ready():
	if enabled:
		$Initialize.start(initial_shoot_cooldown)
		init_bullet_count = bullet_count
		bullet_count = bullet_count + snappedf(Globals.pos_neg(randf_range(0,bullet_count_random)),1.0)
		bullet_count = clamp(bullet_count,1,bullet_count + bullet_count_random)
		Signals.connect("leveling_up",catch_leveling_up)

func _process(delta):
	if enabled:
		if spin > 1.0 and !aim_at_player:
			rotation_degrees += delta * (spin*100)

func _on_initialize_timeout():
	$Loop.start(shot_gap)
	$Initialize.stop()

func _on_loop_timeout():
	if randi_range(1,100) < chance_to_shoot or random_check_passed:
		random_check_passed = true
		
		if aim_at_player:
			if amplitude > 0 and amplitude_look_at_player:
				look_at(Globals.player_position)
				amplitude_look_at_player = false
			elif amplitude == 0:
				look_at(Globals.player_position)
		
		if bullet_count > 0:
			var bullet_inst = bullets.pick_random().instantiate()
			if speed_random > 0:
				bullet_inst.speed = random_output(speed,speed_range,speed_random)
			else:
				bullet_inst.speed = speed
			
			if size_random > 0:
				bullet_inst.size = random_output(size,size_range,size_random)
			else:
				bullet_inst.size = size
			
			bullet_inst.spread = snappedf(Globals.pos_neg(randf_range(0,spread)),1.0)
			bullet_inst.global_position = global_position
			bullet_inst.rotation = rotation
			bullet_inst.spiral_strength = spiral_strength
			bullet_inst.frequency = frequency
			bullet_inst.amplitude = amplitude
			Signals.emit_signal("spawn_bullet",bullet_inst)
			bullet_count -= 1
		else:
			if oneshot:
				queue_free()
			reset_cooldown()
			random_check_passed = false
	else:
		reset_cooldown()

func reset_cooldown():
	amplitude_look_at_player = true
	bullet_count = init_bullet_count + snappedf(Globals.pos_neg(randf_range(0,bullet_count_random)),1.0)
	bullet_count = clamp(bullet_count,1,bullet_count + bullet_count_random)
	$Loop.stop()
	$Initialize.start(shoot_cooldown)

func catch_leveling_up(value):
	leveling_up = value
	if enabled:
		$Initialize.paused = value
		$Loop.paused = value

func random_output(base_val:float,range_amt:Vector3,random_amt:float):
	var random_max = range_amt.y * random_amt
	var random_val = Globals.pos_neg(randf_range(0,random_max))
	var output = base_val + random_val
	output = clamp(output,range_amt.x,range_amt.y)
	return output
