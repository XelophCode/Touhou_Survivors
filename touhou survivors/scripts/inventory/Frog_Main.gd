extends item_base_class

var move : Vector2
var move_speed : float = 80
var velocity : Vector2
@export var explosion : PackedScene
var alt:bool

func _ready():
	rotation = deg_to_rad(randi_range(0,359))
	damage = 1

func _process(delta):
	velocity = move * delta
	$main_body.translate(velocity)

func _on_area_2d_body_entered(body):
	do_damage(body)
	if alt:
		spawn_explosion()


func spawn_explosion():
	var explo = explosion.instantiate()
	explo.global_position = $main_body.global_position
	get_parent().call_deferred("add_child",explo)
	queue_free()

func _on_leap_timeout():
	move = Vector2(move_speed,0)
	$main_body/AnimatedSprite2D.play("leap")

func _on_animated_sprite_2d_animation_finished():
	move = Vector2.ZERO
	$main_body/AnimatedSprite2D.frame = 0

func _on_delete_timeout():
	queue_free()
