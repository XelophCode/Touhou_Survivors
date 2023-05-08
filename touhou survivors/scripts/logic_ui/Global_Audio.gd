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
@export var gap_open : AudioStreamPlayer
@export var fireball : AudioStreamPlayer
@export var fireball_split : AudioStreamPlayer
@export var water : AudioStreamPlayer
@export var megaphone_blast : AudioStreamPlayer
@export var megaphone_bullet : AudioStreamPlayer
@export var master_spark : AudioStreamPlayer
@export var mini_hakkero : AudioStreamPlayer
@export var mochi_mallet_bash : AudioStreamPlayer
@export var mochi_mallet_swing : AudioStreamPlayer
@export var mushroom_explode : AudioStreamPlayer
@export var raincloud : AudioStreamPlayer
@export var persuasion_needle : AudioStreamPlayer
@export var roukanken_flurry : AudioStreamPlayer
@export var roukanken_spin : AudioStreamPlayer
@export var sake_swing : AudioStreamPlayer
@export var sake_bottle_break : AudioStreamPlayer
@export var shanghai_attack : AudioStreamPlayer
@export var knife_throw : AudioStreamPlayer
@export var tripod_swing : AudioStreamPlayer
@export var yinyang : AudioStreamPlayer
@export var youkai_umbrella_jump : AudioStreamPlayer
@export var death_explosion : AudioStreamPlayer
@export var death : AudioStreamPlayer

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
	Signals.connect("gap_open_sfx",catch_gap_open_sfx)
	Signals.connect("fireball_sfx",catch_fireball_sfx)
	Signals.connect("fireball_split_sfx",catch_fireball_split_sfx)
	Signals.connect("water_sfx",catch_water_sfx)
	Signals.connect("megaphone_blast_sfx",catch_megaphone_blast_sfx)
	Signals.connect("megaphone_bullet_sfx",catch_megaphone_bullet_sfx)
	Signals.connect("master_spark_sfx",catch_master_spark_sfx)
	Signals.connect("mini_hakkero_sfx",catch_mini_hakkero_sfx)
	Signals.connect("mochi_mallet_bash_sfx",catch_mochi_mallet_bash_sfx)
	Signals.connect("mochi_mallet_swing_sfx",catch_mochi_mallet_swing_sfx)
	Signals.connect("mushroom_explode_sfx",catch_mushroom_explode_sfx)
	Signals.connect("raincloud_sfx",catch_raincloud_sfx)
	Signals.connect("persuasion_needle_sfx",catch_persuasion_needle_sfx)
	Signals.connect("roukanken_flurry_sfx",catch_roukanken_flurry_sfx)
	Signals.connect("roukanken_spin_sfx",catch_roukanken_spin_sfx)
	Signals.connect("sake_swing_sfx",catch_sake_swing_sfx)
	Signals.connect("sake_bottle_break_sfx",catch_sake_bottle_break_sfx)
	Signals.connect("shanghai_attack_sfx",catch_shanghai_attack_sfx)
	Signals.connect("knife_throw_sfx",catch_knife_throw_sfx)
	Signals.connect("tripod_swing_sfx",catch_tripod_swing_sfx)
	Signals.connect("yinyang_sfx",catch_yinyang_sfx)
	Signals.connect("youkai_umbrella_jump_sfx",catch_youkai_umbrella_jump_sfx)
	Signals.connect("death_explosion_sfx",catch_death_explosion_sfx)
	Signals.connect("death_sfx",catch_death_sfx)

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

func catch_gap_open_sfx():
	gap_open.play()

func catch_fireball_sfx():
	fireball.play()

func catch_fireball_split_sfx():
	fireball_split.play()

func catch_water_sfx():
	water.play()

func catch_megaphone_blast_sfx():
	megaphone_blast.play()

func catch_megaphone_bullet_sfx():
	megaphone_bullet.pitch_scale = randf_range(0.8,1.2)
	megaphone_bullet.play()

func catch_master_spark_sfx():
	master_spark.play()

func catch_mini_hakkero_sfx():
	mini_hakkero.play()

func catch_mochi_mallet_bash_sfx():
	mochi_mallet_bash.play()

func catch_mochi_mallet_swing_sfx():
	mochi_mallet_swing.play()

func catch_mushroom_explode_sfx():
	mushroom_explode.pitch_scale = randf_range(0.9,1.1)
	mushroom_explode.play()

func catch_raincloud_sfx():
	if !raincloud.playing:
		raincloud.play()

func catch_persuasion_needle_sfx():
	persuasion_needle.pitch_scale = randf_range(0.8,1.2)
	persuasion_needle.play()

func catch_roukanken_flurry_sfx():
	roukanken_flurry.play()

func catch_roukanken_spin_sfx():
	roukanken_spin.play()

func catch_sake_swing_sfx():
	if !sake_swing.playing:
		sake_swing.play()

func catch_sake_bottle_break_sfx():
	sake_bottle_break.play()

func catch_shanghai_attack_sfx():
	shanghai_attack.pitch_scale = randf_range(0.8,1.2)
	shanghai_attack.play()

func catch_knife_throw_sfx():
	knife_throw.pitch_scale = randf_range(0.8,1.2)
	knife_throw.play()

func catch_tripod_swing_sfx():
	tripod_swing.play()

func catch_yinyang_sfx():
	yinyang.play()

func catch_youkai_umbrella_jump_sfx():
	youkai_umbrella_jump.play()

func catch_death_explosion_sfx():
	death_explosion.play()

func catch_death_sfx():
	death.play()
