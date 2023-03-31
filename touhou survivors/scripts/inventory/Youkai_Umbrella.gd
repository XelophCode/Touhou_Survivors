extends item_base_class

var attack_count:float = 3.0
var spawn_count:float = 3.0
@export var umbrella:PackedScene

func _ready():
	global_position = Globals.player_position
	$AnimationPlayer.play("initialize")
	damage = randi_range(15,17)
	if alt_fire:
		$main_body/main_body_2.scale = Vector2(3.0,3.0)
	else:
		$main_body/main_body_2.scale = Vector2(1.0,1.0)

func move_umbrella():
	if attack_count > 0:
		$main_body/main_body_2/AnimatedSprite2D.play("move")
		var rand_pos: Vector2 = Vector2(randf_range(-40,40),randf_range(-25,25))
		if $main_body/main_body_2.position.x > rand_pos.x:
			$main_body/main_body_2/AnimatedSprite2D.flip_h = true
		else:
			$main_body/main_body_2/AnimatedSprite2D.flip_h = false
		var tweenmove = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tweenmove.tween_property($main_body/main_body_2,"position",rand_pos,1)
		tweenmove.tween_callback(attack)
		attack_count -= 1.0
	else:
		$AnimationPlayer.play("fade_out")


func attack():
	$AnimationPlayer.play("attack")
	if !alt_fire:
		for i in spawn_count:
			var umbrella_inst = umbrella.instantiate()
			umbrella_inst.global_position = $main_body/main_body_2.global_position
			get_parent().call_deferred("add_child",umbrella_inst)
			await get_tree().create_timer(0.1).timeout

func _on_area_2d_body_entered(body):
	do_damage(body)
