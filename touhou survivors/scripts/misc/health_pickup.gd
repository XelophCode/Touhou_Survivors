extends Node2D

func _on_area_2d_body_entered(body):
	body.hp += 200.0
	body.hp = clamp(body.hp,0,1000.0)
	queue_free()
