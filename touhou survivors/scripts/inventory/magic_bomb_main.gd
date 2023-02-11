extends item_base_class

var flash_amt:float = 0

func _ready():
	damage = 3
	global_position = Globals.player_position
	$AnimationPlayer.play("bomb_throw")
	rotation = deg_to_rad(randi_range(0,359))
	$main_body/MagicBomb.rotation = -rotation

func _process(delta):
	$main_body/MagicBomb.material.set_shader_parameter("flash_modifier",lerp($main_body/MagicBomb.material.get_shader_parameter("flash_modifier"),flash_amt,delta*3))

func flash_amt_one():
	flash_amt = 1.0

func flash_amt_zero():
	flash_amt = 0.0

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
