extends Node

@export var enemy_death : AudioStreamPlayer
@export var hit : AudioStreamPlayer
@export var level_up : AudioStreamPlayer
@export var applause : AudioStreamPlayer
@export var coin_explosion : AudioStreamPlayer
@export var faith : AudioStreamPlayer
@export var crystal : AudioStreamPlayer
@export var tornado : AudioStreamPlayer
@export var player_damage : AudioStreamPlayer
@export var explosion : AudioStreamPlayer
@export var item_grab : AudioStreamPlayer
@export var item_place : AudioStreamPlayer
@export var rotate : AudioStreamPlayer
@export var not_enough_crystals : AudioStreamPlayer
@export var remove_blocked_space : AudioStreamPlayer
@export var gohei : AudioStreamPlayer
@export var amulet : AudioStreamPlayer
@export var bat : AudioStreamPlayer
@export var camera : AudioStreamPlayer
@export var frog_explosion : AudioStreamPlayer
@export var haniwa : AudioStreamPlayer
@export var icicle_explode : AudioStreamPlayer
@export var keystone_small : AudioStreamPlayer
@export var keystone_large : AudioStreamPlayer
@export var leaf_fan : AudioStreamPlayer
@export var arrow : AudioStreamPlayer
@export var star : AudioStreamPlayer

func _ready():
	Signals.connect("enemy_death_sfx",catch_enemy_death_sfx)
	Signals.connect("hit_sfx",catch_hit_sfx)
	Signals.connect("leveling_up",catch_leveling_up)
	Signals.connect("mon_sfx",catch_mon_sfx)
	Signals.connect("faith_sfx",catch_faith_sfx)
	Signals.connect("crystal_sfx",catch_crystal_sfx)
	Signals.connect("tornado_sfx",catch_tornado_sfx)
	Signals.connect("player_damage_sfx", catch_player_damage_sfx)
	Signals.connect("explosion_sfx",catch_explosion_sfx)
	Signals.connect("item_grab_sfx",catch_item_grab_sfx)
	Signals.connect("item_place_sfx",catch_item_place_sfx)
	Signals.connect("rotate_sfx", catch_rotate_sfx)
	Signals.connect("not_enough_crystals_sfx", catch_not_enough_crystals_sfx)
	Signals.connect("remove_blocked_space_sfx", catch_remove_blocked_space_sfx)
	Signals.connect("gohei_sfx",catch_gohei_sfx)
	Signals.connect("amulet_sfx",catch_amulet_sfx)
	Signals.connect("bat_sfx",catch_bat_sfx)
	Signals.connect("camera_sfx",catch_camera_sfx)
	Signals.connect("frog_explosion_sfx",catch_frog_explosion_sfx)
	Signals.connect("haniwa_sfx",catch_haniwa_sfx)
	Signals.connect("icicle_explode_sfx",catch_icicle_explode_sfx)
	Signals.connect("keystone_small_sfx",catch_keystone_small_sfx)
	Signals.connect("keystone_large_sfx",catch_keystone_large_sfx)
	Signals.connect("leaf_fan_sfx",catch_leaf_fan_sfx)
	Signals.connect("arrow_sfx",catch_arrow_sfx)
	Signals.connect("star_sfx",catch_star_sfx)

func catch_enemy_death_sfx():
	if !enemy_death.playing:
		enemy_death.pitch_scale = randf_range(0.8,1.2)
		enemy_death.play()

func catch_hit_sfx():
	hit.pitch_scale = randf_range(0.7,1.3)
	hit.play()

func catch_leveling_up(value):
	if value:
		level_up.play()
		applause.pitch_scale = randf_range(0.9,1.1)
		applause.play()

func catch_mon_sfx():
	coin_explosion.pitch_scale = randf_range(0.7,1.3)
	coin_explosion.play()

func catch_faith_sfx(value):
	faith.pitch_scale = 0.3 + value
	faith.play()

func catch_crystal_sfx():
	crystal.pitch_scale = randf_range(0.7,1.3)
	crystal.play()

func catch_tornado_sfx():
	if !tornado.playing:
		tornado.play()

func catch_player_damage_sfx():
	player_damage.pitch_scale = randf_range(0.9,1.1)
	player_damage.play()

func catch_explosion_sfx():
	if !explosion.playing:
		explosion.play()

func catch_item_grab_sfx():
	item_grab.play()

func catch_item_place_sfx():
	item_place.play()

func catch_rotate_sfx():
	rotate.pitch_scale = randf_range(0.9,1.1)
	rotate.play()

func catch_not_enough_crystals_sfx():
	not_enough_crystals.play()

func catch_remove_blocked_space_sfx():
	remove_blocked_space.play()

func catch_gohei_sfx():
	gohei.pitch_scale = randf_range(0.9,1.1)
	gohei.play()

func catch_amulet_sfx():
	amulet.pitch_scale = randf_range(0.9,1.1)
	amulet.play()

func catch_bat_sfx():
	bat.play()

func catch_camera_sfx():
	camera.play()

func catch_frog_explosion_sfx():
	frog_explosion.pitch_scale = randf_range(0.8,1.2)
	frog_explosion.play()

func catch_haniwa_sfx():
	haniwa.play()

func catch_icicle_explode_sfx():
	icicle_explode.play()

func catch_keystone_small_sfx():
	keystone_small.pitch_scale = randf_range(0.8,1.2)
	keystone_small.play()

func catch_keystone_large_sfx():
	keystone_large.play()

func catch_leaf_fan_sfx():
	leaf_fan.play()

func catch_arrow_sfx():
	arrow.pitch_scale = randf_range(0.9,1.1)
	arrow.play()

func catch_star_sfx():
	star.pitch_scale = randf_range(0.9,1.1)
	star.play()


