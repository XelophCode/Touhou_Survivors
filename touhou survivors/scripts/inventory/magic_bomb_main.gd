extends item_base_class

var flash_amt:float = 0
var alt:bool = false

func _ready():
	damage = randi_range(8,12)
	global_position = Globals.player_position
	if alt:
		$AnimationPlayer.play("bomb_throw")
		rotation = deg_to_rad(randi_range(0,359))
		$main_body/MagicBomb.rotation = -rotation
	else:
		$Timer.start()

func bomb_grow_anim():
	$AnimationPlayer.play("bomb_grow")
	$main_body/Area2D.monitoring = false

func bomb_explosion():
	$main_body/MagicBomb.visible = false
	$main_body/Explosion.visible = true
	$main_body/Explosion.play("default")
	$main_body/Area2D.monitoring = true
	$main_body/Panel.visible = false
	$AnimationPlayer.play("bomb_explosion")

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_explosion_animation_finished():
	queue_free()

func _on_timer_timeout():
	bomb_grow_anim()
