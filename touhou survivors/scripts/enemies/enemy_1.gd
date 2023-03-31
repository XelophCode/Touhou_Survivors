extends enemy_base_class

var leveling_up:bool = false
var max_knockback:float
@export var info:enemy_info

func _ready():
	Signals.connect("leveling_up",catch_leveling_up)
	Signals.connect("despawn_offscreen_enemies", despawn)
	if animation != null:
		animation.play(animation.get_animation_list()[0])

func _physics_process(delta):
	direction_to_player = global_position.direction_to(Globals.player_position).normalized()
	velocity = direction_to_player * delta * (base_speed * speed_mod)
	
	if face_player:
		if direction_to_player.x >= 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	
	if knockback:
		velocity = -direction_to_player * (delta*2000)
		sprite.material.set_shader_parameter("flash_modifier",0.9)
		if $knockback_timer.is_stopped():
			$knockback_timer.start()
	
	
	if leveling_up:
		velocity = Vector2.ZERO
	move_and_slide()
	if hp < 1:
		if alive:
			Signals.emit_signal("enemy_death_sfx")
			Signals.emit_signal("spawn_pickup",global_position,type,tier)
			Signals.emit_signal("spawn_mon",global_position)
			if shadow != null:
				shadow.visible = false
			$knockback_timer.start(100)
			$CollisionShape2D.disabled = true
			if particles != null:
				particles.emitting = false
			if sprite is AnimatedSprite2D:
				sprite.stop()
			alive = false
		sprite.material.set_shader_parameter("dissolve_value",dissolve)
		var tween = create_tween()
		tween.tween_property(self,"dissolve",0.0,delta*60)
		await tween.finished
		
		queue_free()

func despawn():
	if global_position.distance_to(Globals.player_position) > 235:
		queue_free()

func _on_knockback_timer_timeout():
	$knockback_timer.stop()
	sprite.material.set_shader_parameter("flash_modifier",0)
	knockback = false

func catch_leveling_up(value):
	leveling_up = value
