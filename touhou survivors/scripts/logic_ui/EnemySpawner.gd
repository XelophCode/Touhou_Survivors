extends Node2D

var viewport_edge_AA:Vector2
var viewport_edge_BB:Vector2
var enemy_spawn_zone_north:Vector2
var enemy_spawn_zone_west:Vector2
var enemy_spawn_zone_south:Vector2
var enemy_spawn_zone_east:Vector2
var viewport_boundary_offset = 10
var enemy_spawn_edge_offset = 20
var viewport_halved:Vector2 = Vector2(213,120)
var spawn_zones:Array

@export var spawn_limit:int = 200
@export var fairy_red : PackedScene
@export var fairy_green : PackedScene
@export var fairy_blue : PackedScene
@export var divine_spirit : PackedScene
@export var vengeful_spirit : PackedScene
@export var hannya_mask : PackedScene
@export var hell_raven : PackedScene
@export var makai_fairy : PackedScene
@export var obake : PackedScene
@export var lily_white : PackedScene
@export var evil_eye : PackedScene
@export var oni : PackedScene
@export var daiyousei : PackedScene

@onready var enemy_parent := $EnemyParent

var enemies_high_chance : Array
var enemies_low_chance : Array
var speed_mod:float = 1.0
var damage_mod:float = 1.0
var health_mod:float = 1.0
var threat_level:float = 0.0
var leveling_up:bool = false

func _ready():
	Signals.connect("increase_threat",catch_increase_threat)
	Signals.connect("leveling_up",catch_leveling_up)
	enemies_high_chance = [fairy_blue,fairy_green]
	enemies_low_chance = [fairy_red]

func _on_timer_timeout():
	spawn_enemy()

func catch_increase_threat():
	speed_mod += 0.4
	damage_mod += 0.4
	health_mod += 0.2
	threat_level += 1.0
	match threat_level:
		1.0: enemies_low_chance.append(obake)
		2.0: enemies_low_chance.append(hell_raven)
		4.0: enemies_low_chance.append(vengeful_spirit)
		5.0: spawn_enemy(true,hannya_mask)
		6.0: enemies_low_chance.append(evil_eye)
		7.0: enemies_low_chance.append(makai_fairy)
		8.0: enemies_low_chance.append(oni)
		9.0: enemies_low_chance.append(hannya_mask)
		10.0: spawn_enemy(true,lily_white)
		11.0: enemies_low_chance.append(lily_white)
		15.0: spawn_enemy(true,daiyousei)
		16.0: enemies_low_chance.append(daiyousei)
		

func spawn_enemy(special_spawn:bool = false, special_enemy = null):
	if (enemy_parent.get_child_count() < spawn_limit or special_spawn) and !leveling_up:
		var player_pos_x = Globals.player_position.x
		var player_pos_y = Globals.player_position.y
		var viewport_range_x_min:float = player_pos_x - viewport_halved.x
		var viewport_range_x_max:float = player_pos_x + viewport_halved.x
		var viewport_range_y_min:float = player_pos_y - viewport_halved.y
		var viewport_range_y_max:float = player_pos_y + viewport_halved.y
		
		viewport_edge_AA.x = player_pos_x - viewport_halved.x - viewport_boundary_offset
		viewport_edge_AA.y = player_pos_y - viewport_halved.y - viewport_boundary_offset
		viewport_edge_BB.x = player_pos_x + viewport_halved.x + viewport_boundary_offset
		viewport_edge_BB.y = player_pos_y + viewport_halved.y + viewport_boundary_offset
		
		enemy_spawn_zone_west.x = randf_range(viewport_edge_AA.x, viewport_edge_AA.x - enemy_spawn_edge_offset)
		enemy_spawn_zone_west.y = randf_range(viewport_range_y_min, viewport_range_y_max)
		enemy_spawn_zone_south.x = randf_range(viewport_range_x_min, viewport_range_x_max)
		enemy_spawn_zone_south.y = randf_range(viewport_edge_BB.y, viewport_edge_BB.y + enemy_spawn_edge_offset)
		enemy_spawn_zone_east.x = randf_range(viewport_edge_BB.x, viewport_edge_BB.x + enemy_spawn_edge_offset)
		enemy_spawn_zone_east.y = randf_range(viewport_range_y_min, viewport_range_y_max)
		enemy_spawn_zone_north.x = randf_range(viewport_range_x_min, viewport_range_x_max)
		enemy_spawn_zone_north.y = randf_range(viewport_edge_AA.y, viewport_edge_AA.y - enemy_spawn_edge_offset)
		spawn_zones = [enemy_spawn_zone_east,enemy_spawn_zone_north,enemy_spawn_zone_west,enemy_spawn_zone_south]
		var spawn_position = spawn_zones.pick_random()
		
		var inst
		if randf_range(0,1) < 0.8:
			inst = enemies_high_chance.pick_random().instantiate()
		else:
			inst = enemies_low_chance.pick_random().instantiate()
		
		if special_spawn:
			if special_enemy is Array:
				inst = special_enemy.pick_random().instantiate()
			else:
				inst = special_enemy.instantiate()
		else:
			inst.damage *= damage_mod
			inst.speed_mod = speed_mod
			inst.hp *= health_mod
		
		inst.global_position = spawn_position
		enemy_parent.add_child(inst)

func catch_leveling_up(value):
	leveling_up = value
