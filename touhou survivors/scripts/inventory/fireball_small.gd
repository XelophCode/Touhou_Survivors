extends item_base_class

var rot:float

func _ready():
	damage = randi_range(1,3)
	$main_body.rotation_degrees = rot

func _process(delta):
	$main_body/main_body_2.position.x += delta*60 

func _on_area_2d_body_entered(body):
	do_damage(body)
	queue_free()

func _on_timer_timeout():
	queue_free()
