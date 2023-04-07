extends item_base_class

func _ready():
	damage = randi_range(1,3)
	$main_body/main_body_2.rotation_degrees = randf_range(0,359)
	var rand:int = randi_range(0,1)
	$AnimationPlayer.speed_scale = randf_range(0.9,1.1)
	if rand == 1:
		$AnimationPlayer.play("rotate")
	else:
		$AnimationPlayer.play_backwards("rotate")

func _process(delta):
	$main_body.position.y += delta * 60

func _on_area_2d_body_entered(body):
	do_damage(body)
	queue_free()


func _on_timer_timeout():
	queue_free()
