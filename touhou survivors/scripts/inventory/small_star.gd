extends item_base_class

@export var sprite:Sprite2D
var rot:float

func _ready():
	Signals.emit_signal("star_sfx")
	damage = randi_range(1,2)
	sprite.modulate = Globals.random_color()
	$main_body.rotation_degrees = rot

func _process(delta):
	$main_body/main_body_2.position.x += delta * 15

func _on_area_2d_body_entered(body):
	do_damage(body)
	queue_free()

func _on_timer_timeout():
	queue_free()
