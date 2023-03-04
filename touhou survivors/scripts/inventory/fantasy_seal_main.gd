extends item_base_class

@export var sprite:Node
var scale_mod:float
var sprite_color:Color

func _ready():
	rotation_degrees = randf_range(0,359)
	sprite.modulate = Globals.random_color()
	global_position = Globals.player_position
	$main_body/main_body_2.scale += Vector2(scale_mod, scale_mod)
	damage = 10

func _process(delta):
	scale_mod += delta
	scale_mod = clamp(scale_mod,0,3.0)
	$main_body/main_body_2.scale = Vector2(scale_mod, scale_mod)
	$main_body/main_body_2.position.x += delta * 50
	$main_body.rotation_degrees += delta * 50

func _on_area_2d_body_entered(body):
	do_damage(body)

func _on_timer_timeout():
	$AnimationPlayer.play("fade_out")
