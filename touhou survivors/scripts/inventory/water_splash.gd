extends item_base_class

func _ready():
	Signals.emit_signal("water_sfx")
	damage = randi_range(9,12)
	global_position = Globals.player_position
	$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)
	$AnimationPlayer.play("default")
	$main_body/main_body_2/CPUParticles2D.emitting = true

func _process(_delta):
	global_position = Globals.player_position

func _on_area_2d_body_entered(body):
	do_damage(body)
