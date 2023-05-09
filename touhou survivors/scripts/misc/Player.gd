extends CharacterBody2D

enum {RIGHT = 1, LEFT = -1, DOWN = 1, UP = -1, CENTER = 0}

var move:Vector2
var idle_animation:String = "idle_down"
@export var walk_animations : AnimatedSprite2D
@export var move_speed:float = 3000
@export var starting_items: StartingItemArrayResource

@export_group("character_spritesheets")
@export var reimu_spritesheet : Texture2D
@export var marisa_spritesheet : Texture2D
@export var remilia_spritesheet : Texture2D
@export var aya_spritesheet : Texture2D
@export var suika_spritesheet : Texture2D
@export var reisen_spritesheet : Texture2D
@export var youmu_spritesheet : Texture2D
@export var cirno_spritesheet : Texture2D
@export_group("character_anims")
@export var reimu_anims : SpriteFrames
@export var marisa_anims : SpriteFrames
@export var remilia_anims : SpriteFrames
@export var aya_anims : SpriteFrames
@export var suika_anims : SpriteFrames
@export var reisen_anims : SpriteFrames
@export var youmu_anims : SpriteFrames
@export var cirno_anims : SpriteFrames
@export_group("character_loadouts")
@export var reimu_loadout : StartingItemArrayResource
@export var marisa_loadout : StartingItemArrayResource
@export var remilia_loadout : StartingItemArrayResource
@export var aya_loadout : StartingItemArrayResource
@export var suika_loadout : StartingItemArrayResource
@export var reisen_loadout : StartingItemArrayResource
@export var youmu_loadout : StartingItemArrayResource
@export var cirno_loadout : StartingItemArrayResource

var power:int
var faith:float
var faith_max:float = 50.0
var current_items:Array
var hp:float = 100.0
var damage_taken:float
var teleport_pos:Vector2
var tweening_focus:bool = false
var focusing:bool = false
var check_for_move:bool = false
var leveling_up:bool = false
var initial_move_speed:float
var afterimage_scale:float = 1.0
var inverted_health_mod:float
var inverted_scale_mod:float
var starting_loadout_override:bool = false
var alive:bool = true
var last_diagonal:Vector2
var last_diagonal_anim:String
var last_diagonal_h_flip:bool
var moving_diagonaly:bool = false
var currently_moving_diagonaly:bool = false
var crystal:float
var magic_circle_size:float = 1.0
var emit_damage_taken:bool = true
var damage_entities:Array
var last_damage_taken:enemy_info
var move_right = "move_disabled"
var move_left = "move_disabled"
var move_up = "move_disabled"
var move_down = "move_disabled"

func _ready():
	Globals.player_alive = true
	Globals.player_z_index = z_index
	Globals.one_time_spawns = []
	var custom_loadout:StartingItemArrayResource
	if starting_items != null:
		custom_loadout = starting_items
		starting_loadout_override = true
	match Globals.current_character:
		Globals.Reimu: walk_animations.sprite_frames = reimu_anims; starting_items = reimu_loadout;
		Globals.Marisa: walk_animations.sprite_frames = marisa_anims; starting_items = marisa_loadout;
		Globals.Remilia: walk_animations.sprite_frames = remilia_anims; starting_items = remilia_loadout; 
		Globals.Aya: walk_animations.sprite_frames = aya_anims; starting_items = aya_loadout
		Globals.Suika: walk_animations.sprite_frames = suika_anims; starting_items = suika_loadout
		Globals.Reisen: walk_animations.sprite_frames = reisen_anims; starting_items = reisen_loadout
		Globals.Youmu: walk_animations.sprite_frames = youmu_anims; starting_items = youmu_loadout
		Globals.Cirno: walk_animations.sprite_frames = cirno_anims; starting_items = cirno_loadout
	
	$death.sprite_frames = walk_animations.sprite_frames
	
	if starting_loadout_override:
		starting_items = custom_loadout
	
	initial_move_speed = move_speed
	$magic_circle_spins.play("spin")
	$Healthbar.max_value = hp
	Signals.connect("modify_player_speed",modify_speed)
	Signals.connect("modify_player_scale",modify_scale)
	Signals.connect("leveling_up",catch_leveling_up)
	Signals.connect("update_crystal",catch_update_crystal)
	Signals.connect("decrease_crystal_count",catch_decrease_crystal_count)
	Signals.connect("game_start_complete",catch_game_start_complete)
	Signals.connect("delete_player",catch_delete_player)
	await get_tree().create_timer(0.1).timeout
	var counter:int = 0
	if starting_items != null:
		for item in starting_items.starting_item:
			if item.item.one_time_spawn:
				Globals.one_time_spawns.append(item.item.name[item.item.item_name])
			Signals.emit_signal("add_weapon",item.item.spawnable,counter,item.cooldown,item.item.active,item.item.icon,item.occult_orb,true)
			counter += 1

func _physics_process(delta):
	Globals.photo_dest = $PhotoPos.global_position
	$Healthbar.value = hp
	move = Vector2.ZERO
	
	
	var magic_circle_scale : float = (crystal / 50) * 2 + 1
	magic_circle_scale = clamp(magic_circle_scale,1.0,3.0)
	$MagicCircle.scale = Vector2(magic_circle_scale,magic_circle_scale)
	
	if !leveling_up:
		if hp < $Healthbar.max_value:
			hp += 0.01
		hp -= damage_taken
		if Input.is_action_pressed("focus") and !tweening_focus and !focusing:
			magic_circle_tween_on(delta)
		
		if !Input.is_action_pressed("focus") and !tweening_focus:
			magic_circle_tween_off(delta)
		
		move.x = Input.get_action_raw_strength(move_right) - Input.get_action_raw_strength(move_left)
		move.y = Input.get_action_raw_strength(move_down) - Input.get_action_raw_strength(move_up)
		if damage_taken > 0:
			$damage_effect.emitting = true
			if emit_damage_taken:
				Signals.emit_signal("taking_damage",true)
				emit_damage_taken = false
		else:
			$damage_effect.emitting = false
			if !emit_damage_taken:
				Signals.emit_signal("taking_damage",false)
				emit_damage_taken = true
	else:
		$damage_effect.emitting = false
		if check_for_move:
			if move == Vector2.ZERO:
				Signals.emit_signal("player_not_moving_in_pause")
				check_for_move = false
	
	currently_moving_diagonaly = moving_diagonaly
	if move.x != 0 and move.y != 0:
		moving_diagonaly = true
	else:
		moving_diagonaly = false
	
	if currently_moving_diagonaly and !moving_diagonaly:
		$DiagonalInput.start()
	
	if hp < 1 and !leveling_up:
		move = Vector2.ZERO
		velocity = Vector2.ZERO
		if alive:
			Globals.player_alive = false
			$death.visible = true
			$death_explosion.visible = true
			walk_animations.play("idle_down")
			$WalkAnimations/Halo.visible = true
			$AnimationPlayer.play("death")
			Signals.emit_signal("death_explosion_sfx")
			Signals.emit_signal("death_sfx")
			Signals.emit_signal("stop_weapons")
			Signals.emit_signal("game_over",last_damage_taken)
			Signals.emit_signal("game_over_music")
			alive = false
	
	if !Input.is_action_pressed("focus"):
		if move != Vector2(0,0):
			Globals.player_facing = move
			
			match move:
				Vector2(RIGHT,UP): last_diagonal = move; last_diagonal_anim = "idle_diagonal_up"; last_diagonal_h_flip = true;
				Vector2(LEFT,UP): last_diagonal = move; last_diagonal_anim = "idle_diagonal_up"; last_diagonal_h_flip = false;
				Vector2(LEFT,DOWN): last_diagonal = move; last_diagonal_anim = "idle_diagonal_down"; last_diagonal_h_flip = false;
				Vector2(DOWN,RIGHT): last_diagonal = move; last_diagonal_anim = "idle_diagonal_down"; last_diagonal_h_flip = true;
				_: pass
		
		match move:
			Vector2.RIGHT: walk_animations.play("walk_side"); walk_animations.flip_h = true; idle_animation = "idle_side"
			Vector2(RIGHT,UP): walk_animations.play("walk_diagonal_up"); walk_animations.flip_h = true; idle_animation = "idle_diagonal_up"
			Vector2.UP: walk_animations.play("walk_up"); walk_animations.flip_h = false; idle_animation = "idle_up"
			Vector2(LEFT,UP): walk_animations.play("walk_diagonal_up"); walk_animations.flip_h = false; idle_animation = "idle_diagonal_up"
			Vector2.LEFT: walk_animations.play("walk_side"); walk_animations.flip_h = false; idle_animation = "idle_side"
			Vector2(LEFT,DOWN): walk_animations.play("walk_diagonal_down"); walk_animations.flip_h = false; idle_animation = "idle_diagonal_down"
			Vector2.DOWN: walk_animations.play("walk_down"); walk_animations.flip_h = false; idle_animation = "idle_down"
			Vector2(DOWN,RIGHT): walk_animations.play("walk_diagonal_down"); walk_animations.flip_h = true; idle_animation = "idle_diagonal_down"
			_: pass
	
	if move == Vector2.ZERO:
		walk_animations.play(idle_animation)
	
	Globals.player_position = global_position
	
	velocity = move.normalized() * (delta) * move_speed
	if Input.is_action_pressed("focus"):
		velocity = velocity/2
	
	
	
	Globals.player_hp = hp
	move_and_slide()


func _on_hitbox_body_entered(body):
	take_damage(body,1.0)
	damage_entities.push_front(body.info)
	last_damage_taken = damage_entities[0]

func _on_hitbox_body_exited(body):
	take_damage(body,-1.0)
	damage_entities.erase(body.info)

func take_damage(entity,addsub:float):
	damage_taken += entity.damage * addsub

func modify_speed(interaction:String,speed_mod:float = 1.0):
	match interaction:
		"initialize": move_speed *= speed_mod
		"modify": move_speed = initial_move_speed * speed_mod
		"remove": move_speed = initial_move_speed

func modify_scale(interaction:String, scale_mod:float, health_mod:float, inv_health_mod:float):
	match interaction:
		"initialize":
			scale.x = scale_mod; scale.y = scale_mod
			$Healthbar.max_value *= health_mod
			afterimage_scale = scale_mod
			hp *= health_mod
			inverted_health_mod = inv_health_mod
		"modify":
			scale.x = scale_mod; scale.y = scale_mod
			$Healthbar.max_value *= inverted_health_mod
			$Healthbar.max_value *= health_mod
			afterimage_scale = scale_mod
			hp *= inverted_health_mod
			hp *= health_mod
			inverted_health_mod = inv_health_mod
		"remove":
			scale.x = 1.0; scale.y = 1.0
			$Healthbar.max_value *= inverted_health_mod
			afterimage_scale = 1.0
			hp *= inverted_health_mod


func _on_item_pull_area_entered(area):
	
	area.owner.move_towards_player = true

func _on_item_pull_area_exited(area):
	area.owner.move_towards_player = false

func magic_circle_tween_on(delta):
	focusing = true
	tweening_focus = true
	$MagicCircle/Sprites.visible = true
	var tween = create_tween()
	var current_scale:Vector2 = $MagicCircle/Sprites.scale
	$MagicCircle/Sprites.scale = Vector2.ZERO
	tween.tween_property($MagicCircle/Sprites,"scale",current_scale,delta*20)
	await tween.finished
	tweening_focus = false

func magic_circle_tween_off(delta):
	focusing = false
	tweening_focus = true
	var tween = create_tween()
	var current_scale = $MagicCircle/Sprites.scale
	tween.tween_property($MagicCircle/Sprites,"scale",Vector2.ZERO,delta*20)
	await tween.finished
	$MagicCircle/Sprites.visible = false
	$MagicCircle/Sprites.scale = current_scale
	tweening_focus = false

func catch_leveling_up(value):
	if value:
		leveling_up = true
		check_for_move = true
		$Healthbar.max_value *= 1.1
		Signals.emit_signal("increase_max_hp",$Healthbar.max_value)
		hp *= 1.1
	else:
		leveling_up = false

func _on_spawn_afterimage_timeout():
	Signals.emit_signal("update_afterimage",walk_animations.sprite_frames,walk_animations.animation,walk_animations.frame,walk_animations.flip_h,afterimage_scale)

func _on_sun_ray_anim_timer_timeout():
	$SunRaysAnims.play("sun_ray")


func _on_diagonal_input_timeout():
	if move == Vector2.ZERO and !Input.is_action_pressed("focus"):
		idle_animation = last_diagonal_anim
		walk_animations.flip_h = last_diagonal_h_flip
		Globals.player_facing = last_diagonal

func _on_hitbox_area_entered(area):
	take_damage(area.get_parent().get_parent().get_parent(),1.0)
#	damage_entities.push_front(area)
#	print(str(damage_entities))

func _on_hitbox_area_exited(area):
	take_damage(area.get_parent().get_parent().get_parent(),-1.0)
#	damage_entities.erase(area)

func catch_update_crystal(_value):
	crystal += 1
	crystal = clamp(crystal,0,50.0)

func catch_decrease_crystal_count():
	crystal -= 10
	crystal = clamp(crystal,0,50.0)

func catch_game_start_complete():
	move_right = "move_right"
	move_left = "move_left"
	move_up = "move_up"
	move_down = "move_down"

func catch_delete_player():
	queue_free()

