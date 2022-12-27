extends item_base_class

func _ready():
	rotation = deg_to_rad(randi_range(0,359))
	damage = 1
	$AnimationPlayer.play("move")

func _on_area_2d_body_entered(body):
	do_damage(body)
	queue_free()

func delete():
	queue_free()
