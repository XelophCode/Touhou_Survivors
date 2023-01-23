extends item_base_class

@onready var main_body := $main_body
@onready var animated_sprite := $main_body/sprite/animations
@onready var sprite := $main_body/sprite/sprite
@onready var shadow := $main_body/sprite/shadow

var size_mod:float = 1.0
var bottle_broken:bool = false

func _ready():
	rotation = deg_to_rad(randi_range(0,359))
	global_position = Globals.player_position
	$AnimationPlayer.play("throw")
	$AnimationPlayer.seek(0)
	if occult_orb:
		size_mod = 2.5; damage = 4
	else:
		size_mod = 1.2; damage = 1

func _on_hitbox_body_entered(body):
	do_damage(body)

func break_bottle():
	$main_body/sprite/animations.rotation -= rotation
	shadow.visible = false
	sprite.visible = false
	animated_sprite.visible = true
	animated_sprite.play("bottle_break")
	bottle_broken = true
	animated_sprite.set_frame(0)

func _physics_process(delta):
	if bottle_broken:
		$main_body.scale.x = lerp($main_body.scale.x,size_mod,1 * delta)
		$main_body.scale.y = lerp($main_body.scale.y,size_mod,1 * delta)

func _on_animations_animation_finished():
	if animated_sprite.animation == "bottle_break":
		animated_sprite.play("puddle")

func delete():
	queue_free()

func _on_timer_timeout():
	$AnimationPlayer.play("fade_out")

func _on_hitbox_toggle_timeout():
	$main_body/hitbox.monitoring = false
	$main_body/hitbox.monitoring = true
