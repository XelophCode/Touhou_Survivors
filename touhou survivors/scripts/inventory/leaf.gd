extends item_base_class

var alt:bool = false

func _ready():
	damage = randi_range(3,5)
	global_position = Globals.player_position
	
	if alt:
		$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing) + randf_range(-15,15)
		$AnimationPlayer.speed_scale = randf_range(1.0,1.2)
		$AnimationPlayer.play("leaf_move")
		tween_move()
	else:
		rotation_degrees = randf_range(0,359)
		tween_move()
		$AnimationPlayer.speed_scale = randf_range(0.8,1.2)
		$AnimationPlayer.play("leaf_spin")
		

func _process(_delta):
	if !alt:
		global_position = Globals.player_position

func tween_move():
	var rand_pos:Vector2 = Vector2(randf_range(0,10),0)
	var tween_1 = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween_1.tween_property($main_body/main_body_2,"position",rand_pos,0.8)

func _on_area_2d_body_entered(body):
	do_damage(body)
	if !alt:
		queue_free()

func leaf_spin_2():
	$AnimationPlayer.play("leaf_spin_2")
