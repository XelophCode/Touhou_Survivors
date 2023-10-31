extends item_base_class

func _ready():
	global_position = Globals.player_position
	damage = 0

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_animation_player_animation_finished(anim_name):
	queue_free()
