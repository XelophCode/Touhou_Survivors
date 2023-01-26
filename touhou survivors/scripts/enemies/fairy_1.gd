extends enemy_base_class

func _ready():
	Signals.connect("despawn_offscreen_enemies", despawn)
	if animation != null:
		animation.play(animation.get_animation_list()[0])

func _physics_process(delta):
	direction_to_player = global_position.direction_to(Globals.player_position).normalized()
	velocity = direction_to_player * delta * (base_speed * speed_mod)
	
	if face_player:
		if direction_to_player.x >= 0:
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1
	
	if knockback:
		velocity *= -6
		sprite.material.flash_modifier = 0.9
		if $knockback_timer.is_stopped():
			$knockback_timer.start()
	
	if Globals.leveling_up:
		velocity = Vector2.ZERO
	move_and_slide()
	if hp < 1:
		if alive:
			Signals.emit_signal("spawn_pickup",global_position,type)
			if shadow != null:
				shadow.visible = false
			$knockback_timer.start(100)
			$CollisionShape2D.disabled = true
			if particles != null:
				particles.emitting = false
			if sprite is AnimatedSprite2D:
				sprite.stop()
			alive = false
		sprite.material.dissolve_value = dissolve
		var tween = create_tween()
		tween.tween_property(self,"dissolve",0.0,delta*60)
		await tween.finished
		
		queue_free()

func despawn():
	if global_position.distance_to(Globals.player_position) > 400:
		queue_free()

func _on_knockback_timer_timeout():
	$knockback_timer.stop()
	sprite.material.set_shader_parameter("flash_modifier",0)
	knockback = false
