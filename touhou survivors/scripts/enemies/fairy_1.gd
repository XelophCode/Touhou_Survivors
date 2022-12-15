extends CharacterBody2D

var direction_to_player:Vector2
var hp:int = 5
var damage:float = 1

func _ready():
	Signals.connect("despawn_offscreen_enemies", despawn)

func _physics_process(delta):
	direction_to_player = global_position.direction_to(Globals.player_position).normalized()
	velocity = direction_to_player * delta * 300
	if Globals.leveling_up:
		velocity = Vector2.ZERO
	move_and_slide()
	if hp < 1:
		$AnimatedSprite2D.play("death")
		if $AnimatedSprite2D.frame == 5:
			Signals.emit_signal("spawn_power_item",global_position)
			queue_free()

func despawn():
	if global_position.distance_to(Globals.player_position) > 400:
		queue_free()
