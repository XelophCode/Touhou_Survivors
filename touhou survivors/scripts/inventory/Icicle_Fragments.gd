extends item_base_class

var alt:bool = false
var direction:bool = false
var move_dir:float
var move:Vector2

func _ready():
	if direction:
		move_dir = -1.0
	else:
		move_dir = 1.0
	damage = randi_range(1,3)
	if alt:
		rotation = deg_to_rad(randi_range(0,359))
		$AnimationPlayer.play("move")
	else:
		move = Vector2(2*move_dir,0)

func _process(delta):
	$main_body.translate(move*(delta*60))

func _on_area_2d_body_entered(body):
	do_damage(body)
	queue_free()

func delete():
	queue_free()

func _on_timer_timeout():
	queue_free()
