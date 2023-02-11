extends AnimatedSprite2D

var alpha_value:float = 1.0

func _process(delta):
	material.alpha = alpha_value
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self,"alpha_value",0.0, delta*160)
	await tween.finished
	queue_free()
