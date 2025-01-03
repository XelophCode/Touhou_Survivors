extends item_base_class

var move : Vector2
var enemies_to_track : Array
@export var move_speed : float = 120
var starting_move : Vector2
var alt:bool = false


func _ready():
	Signals.emit_signal("amulet_sfx")
	damage = randi_range(1,2)
	global_position = Globals.player_position
	if alt:
		starting_move = Vector2(2,0)
	else:
		starting_move = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
		$main_body/amulet_0.rotation = atan2(starting_move.y,starting_move.x)
		move_speed += randf_range(0,20)

func _process(delta):
	if alt:
		$main_body/amulet_0.translate(starting_move*(delta*60))
	else:
		move = (starting_move * move_speed) * delta
		if enemies_to_track != []:
			if instance_from_id(enemies_to_track[0]) != null:
				var direction_to_enemy = $main_body/amulet_0.global_position.direction_to(instance_from_id(enemies_to_track[0]).global_position)
				move = lerp(move,direction_to_enemy * move_speed * delta,delta*50) 
				$main_body/amulet_0.rotation = lerp_angle($main_body/amulet_0.rotation,atan2(direction_to_enemy.y,direction_to_enemy.x),delta * 50)
		$main_body/amulet_0.translate(move)

func _on_tracker_body_entered(body):
	if alt:
		pass
	else:
		if !enemies_to_track.has(body.get_instance_id()):
			enemies_to_track.append(body.get_instance_id())

func _on_damage_body_entered(body):
	do_damage(body)
	queue_free()

func _on_timer_timeout():
	queue_free()
