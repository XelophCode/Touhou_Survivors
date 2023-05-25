extends Node2D

var rand_pos_neg:Array = [-60,60]
@export var all_obstacles:all_obstacles_resource
var spawn_count:float = 80

func _ready():
	Signals.connect("go_to_main_menu",catch_go_to_main_menu)
	Signals.connect("game_start_complete",catch_game_start_complete)
	Signals.connect("game_over_music",catch_game_over_music)
	var x_spawn:Array = []
	var y_spawn:Array = []
	var count:float = 1
	for i in spawn_count/2:
		x_spawn.append(count)
		y_spawn.append(count)
		count += 1
	count = -1
	for ii in spawn_count/2:
		x_spawn.append(count)
		y_spawn.append(count)
		count -= 1
	x_spawn.shuffle()
	y_spawn.shuffle()
	
	for spawn in spawn_count:
		var xsp = x_spawn.pop_front()
		var ysp = y_spawn.pop_front()
		var spawn_location = Vector2(xsp,ysp) * rand_pos_neg.pick_random()
		var obst_inst = all_obstacles.obstacles.pick_random().instantiate()
		obst_inst.global_position = spawn_location
		$obstacle_parent.add_child(obst_inst)
	

func catch_go_to_main_menu():
	get_tree().change_scene_to_file("res://prefabs/levels/main_menu.tscn")
	

func catch_game_start_complete():
	pass


func _on_intro_ready():
	await get_tree().create_timer(3.0).timeout
	$music/music.play()

func catch_game_over_music():
	$music/music.stop()
	$music/game_over.play()
