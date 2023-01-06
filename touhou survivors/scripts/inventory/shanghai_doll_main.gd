extends item_base_class

var move_amt:float = 50
var loops:int = 0

func _ready():
	
	damage = 1
	$main_body.global_position = Globals.player_position
	
	movetween()

func _physics_process(_delta):
	queue_redraw()

func movetween():
	var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property($main_body,"global_position",Globals.player_position + random_pos(),1)
	tween.tween_callback(attack)

func _draw():
	draw_line(Globals.player_position,$main_body.global_position,Color(1,1,1,1))

func random_pos():
	return Vector2(randf_range(-move_amt,move_amt),randf_range(-move_amt,move_amt))

func attack():
	$main_body/Shanghai.play("default")
	$main_body/Area2D.monitoring = true
	$AnimationPlayer.play("attack")
	loops += 1
	await get_tree().create_timer(randf_range(0.4,0.7)).timeout
	$main_body/Area2D.monitoring = false
	if loops < 3:
		movetween()
	else:
		$AnimationPlayer.play("fade_out")

func _on_shanghai_animation_finished():
	$main_body/Shanghai.stop()

func _on_area_2d_body_entered(body):
	do_damage(body)
