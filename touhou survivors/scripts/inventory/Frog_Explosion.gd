extends item_base_class

func _ready():
	damage = 1
	$AnimatedSprite2D.play("explosion")

func _on_animated_sprite_2d_animation_finished():
	queue_free()

func _on_area_2d_body_entered(body):
	do_damage(body)
