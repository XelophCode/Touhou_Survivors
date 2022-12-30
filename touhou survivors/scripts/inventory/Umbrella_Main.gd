extends item_base_class

func _ready():
	damage = 6
	global_position = Globals.player_position
	$AnimationPlayer2.play("move")
	$AnimationPlayer.play("spin")

func _on_area_2d_body_entered(body):
	do_damage(body)
	queue_free()
