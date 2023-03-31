extends item_base_class

func _ready():
	damage = 4
	$main_body.rotation_degrees = randf_range(0,359.9)

func _process(delta):
	$main_body/main_body_2.position.x += delta * 80

func _on_area_2d_body_entered(body):
	do_damage(body)
