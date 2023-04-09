extends item_base_class

@export var animated_sprite:Node
@export var sprite:Node
@export var shadow:Node
@export var main_body:Node

var size_mod:float = 3.0
var bottle_broken:bool = false
var rotation_add:float
var rotation_max:float
var rotation_min:float

func _ready():
	if alt_fire:
		scale = Vector2(1.5,1.5)
		global_position = Globals.player_position
		damage = randi_range(10,15)
		$Timer.start()
		$HitboxToggle.start()
		rotation = deg_to_rad(randi_range(0,359))
		$AnimationPlayer.play("throw")
		$AnimationPlayer.seek(0)
	else:
		Signals.emit_signal("sake_swing_sfx")
		$main_body.global_position = Globals.player_position
		damage = randi_range(12,17)
		$main_body.rotation_degrees = Globals.cardinal_direction_to_rotation(Globals.player_facing)
		rotation_add = $main_body.rotation_degrees
		rotation_min = $main_body.rotation_degrees - 180
		rotation_max = $main_body.rotation_degrees
		$AnimationPlayer.play("swing")
	



func _on_hitbox_body_entered(body):
	do_damage(body)

func break_bottle():
	Signals.emit_signal("sake_bottle_break_sfx")
	$main_body/main_body_2/sprite/animations.rotation -= rotation
	shadow.visible = false
	sprite.visible = false
	animated_sprite.visible = true
	animated_sprite.play("bottle_break")
	bottle_broken = true
	animated_sprite.set_frame(0)

func _process(delta):
	if alt_fire:
		if bottle_broken:
			$main_body.scale.x = lerp($main_body.scale.x,size_mod, delta)
			$main_body.scale.y = lerp($main_body.scale.y,size_mod, delta)
	else:
		queue_redraw()
		$main_body.global_position = Globals.player_position
		rotation_add -= delta*200
		rotation_add = clamp(rotation_add,rotation_min,rotation_max)
		$main_body.rotation_degrees = rotation_add

func _on_animations_animation_finished():
	if animated_sprite.animation == "bottle_break":
		animated_sprite.play("puddle")

func _on_timer_timeout():
	if alt_fire:
		$AnimationPlayer.play("fade_out")

func _on_hitbox_toggle_timeout():
	if alt_fire:
		$main_body/main_body_2/hitbox.monitoring = false
		$main_body/main_body_2/hitbox.monitoring = true

func _draw():
	if !alt_fire:
		draw_line(Globals.player_position,$main_body/main_body_2.global_position,Color(1,0.1,0.1,1),1)
	else:
		pass
