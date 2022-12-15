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
@export var spawn_limit:int = 100
@onready var enemy := preload("res://prefabs/enemies/fairy_1.tscn")
@onready var enemy_parent := $EnemyParent


func _on_timer_timeout():
	if enemy_parent.get_child_count() < spawn_limit:
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
		
		var inst = enemy.instantiate()
		inst.global_position = spawn_position
		enemy_parent.add_child(inst)
