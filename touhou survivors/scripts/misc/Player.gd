extends CharacterBody2D

enum {RIGHT = 1, LEFT = -1, DOWN = 1, UP = -1, CENTER = 0}

var move:Vector2
var idle_animation:String = "idle_down"
@onready var walk_animations := $WalkAnimations
@export var move_speed:float = 1000
@export var starting_items: StartingItemArrayResource
var power:int
var current_items:Array
var hp:float = 100.0
var damage_taken:float
var teleport_pos:Vector2


func _ready():
	$Healthbar.max_value = hp
	Signals.connect("modify_player_speed",modify_speed)
	Signals.connect("modify_player_scale",modify_scale)
	Signals.connect("gap_teleport",gap_teleport)
	Signals.connect("gap_finish",gap_finish)
	await get_tree().create_timer(0.1).timeout
	var counter:int = 0
	if starting_items != null:
		for item in starting_items.starting_item:
			if item.item.one_time_spawn:
				Globals.one_time_spawns.append(item.item.name[item.item.item_name])
			Signals.emit_signal("add_weapon",item.item.spawnable,counter,item.cooldown,item.item.active,item.item.icon,item.stack,true)
			counter += 1


func _physics_process(delta):
	$Healthbar.value = hp
	
	move = Vector2.ZERO
	
	if !Globals.leveling_up:
		move.x = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
		move.y = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
		if damage_taken != 0:
			$damage_effect.emitting = true
		else:
			$damage_effect.emitting = false
	else:
		$damage_effect.emitting = false
	
	if move != Vector2(0,0):
		Globals.player_facing = move
	
	match move:
		Vector2.RIGHT: walk_animations.play("walk_side"); walk_animations.flip_h = true; idle_animation = "idle_side"
		Vector2(RIGHT,UP): walk_animations.play("walk_diagonal_up"); walk_animations.flip_h = true; idle_animation = "idle_diagonal_up"
		Vector2.UP: walk_animations.play("walk_up"); walk_animations.flip_h = false; idle_animation = "idle_up"
		Vector2(LEFT,UP): walk_animations.play("walk_diagonal_up"); walk_animations.flip_h = false; idle_animation = "idle_diagonal_up"
		Vector2.LEFT: walk_animations.play("walk_side"); walk_animations.flip_h = false; idle_animation = "idle_side"
		Vector2(LEFT,DOWN): walk_animations.play("walk_diagonal_down"); walk_animations.flip_h = false; idle_animation = "idle_diagonal_down"
		Vector2.DOWN: walk_animations.play("walk_down"); walk_animations.flip_h = false; idle_animation = "idle_down"
		Vector2(DOWN,RIGHT): walk_animations.play("walk_diagonal_down"); walk_animations.flip_h = true; idle_animation = "idle_diagonal_down"
		Vector2.ZERO: walk_animations.play(idle_animation)
	
	Globals.player_position = global_position
	velocity = move.normalized() * delta * move_speed
	
	move_and_slide()
	
	hp -= damage_taken

func _on_hitbox_body_entered(body):
	damage_taken += body.damage
	Signals.emit_signal("player_damaged")

func _on_hitbox_body_exited(body):
	damage_taken -= body.damage

func modify_speed(speed_mod:float):
	move_speed *= speed_mod

func modify_scale(scale_mod:float, health_mod:float):
	scale.x = scale_mod; scale.y = scale_mod
	$Healthbar.max_value *= health_mod
	hp *= scale_mod

func gap_teleport(center_player:Vector2,teleport_destination:Vector2):
	$AnimationPlayer.play("gap_teleport_in")
	teleport_pos = teleport_destination
	var tween = create_tween()
	tween.tween_property(self,"global_position",center_player,0.25)
	tween.tween_callback(gap_camera_tween.bind(teleport_destination))

func gap_camera_tween(camera_destination:Vector2):
	Signals.emit_signal("gap_camera_tween",camera_destination)

func gap_finish():
	$AnimationPlayer.play("gap_teleport_out")
	global_position = teleport_pos

func gap_close():
	Signals.emit_signal("gap_close")
