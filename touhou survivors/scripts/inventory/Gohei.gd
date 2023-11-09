extends item_base_class

var anim_counter:int = 0

func _ready():
	global_position = Globals.player_position
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	Signals.emit_signal("gohei_sfx")
	if alt_fire:
		rotation_degrees += 90
	damage = randi_range(13,17)


func _process(_delta):
	global_position = Globals.player_position


func _on_hitbox_body_entered(body):
	do_damage(body)


func repeat():
	if anim_counter == 0:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("slash_move")
		Signals.emit_signal("gohei_sfx")
		anim_counter += 1
	else:
		queue_free()


func flip():
	if anim_counter > 0:
		$main_body.scale.x = -1



