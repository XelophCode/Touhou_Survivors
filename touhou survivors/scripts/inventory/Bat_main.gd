extends item_base_class

var random_dest:float = 100.0

func _ready():
	damage = 1
	$main_body.global_position = Globals.player_position
	tweenmove()

func tweenmove():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property($main_body,"global_position",Globals.player_position + random_pos(),randf_range(2.5,3.5))
	tween.tween_callback(delete)

func delete():
	queue_free()

func random_pos():
	return Vector2(randf_range(-random_dest,random_dest),-200)

func _on_area_2d_body_entered(body):
	do_damage(body)
