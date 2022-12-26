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

func _ready():
	$Healthbar.max_value = hp
	Signals.connect("modify_player_speed",modify_speed)
	Signals.connect("modify_player_scale",modify_scale)
	await get_tree().create_timer(0.1).timeout
	var counter:int = 0
	if starting_items != null:
		for item in starting_items.starting_item:
			if !item.item.active:
				Globals.passive_items.append(item.item.name[item.item.item_name])
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

func _on_hitbox_body_exited(body):
	damage_taken -= body.damage

func modify_speed(speed_mod:float):
	move_speed *= speed_mod

func modify_scale():
	scale.x = 2; scale.y = 2
	$Healthbar.max_value *= 2
	hp *= 2
