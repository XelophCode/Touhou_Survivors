extends Node

@export var enemy_death : AudioStreamPlayer
@export var hit : AudioStreamPlayer
@export var level_up : AudioStreamPlayer
@export var applause : AudioStreamPlayer

func _ready():
	Signals.connect("enemy_death_sfx",catch_enemy_death_sfx)
	Signals.connect("hit_sfx",catch_hit_sfx)
	Signals.connect("leveling_up",catch_leveling_up)

func catch_enemy_death_sfx():
	enemy_death.play()

func catch_hit_sfx():
	hit.play()

func catch_leveling_up(value):
	if value:
		level_up.play()
		applause.play()
