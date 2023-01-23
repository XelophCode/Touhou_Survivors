extends item_base_class

@onready var collision := $main_body/Hitbox
@onready var main_body := $main_body
var move:Vector2
var current_rotation:float
var pause:bool = false

@export var initial_magnitude:float = 1
@export var magnitude_increase_factor:float = 1.008
@export var rotational_force_degrees:int = 5

func _ready():
	damage = 1
	Signals.connect("leveling_up",leveling_up)
	rotation = deg_to_rad(randi_range(0,359))
	$spin.play("spin")
	$fade.play("fade_in")
	move.x = initial_magnitude
	global_position = Globals.player_position
	
	if occult_orb:
		scale.x = 2; scale.y = 2
	else:
		scale.x = 1; scale.y = 1
	

func _physics_process(delta):
	if !pause:
		move = move.rotated(deg_to_rad(rotational_force_degrees)) * magnitude_increase_factor * delta * 60
		main_body.translate(move)
		global_position = Globals.player_position

func _on_timer_timeout():
	$fade.play("fade_out")

func fade_out_complete():
	queue_free()

func _on_hitbox_body_entered(body):
	do_damage(body)

func leveling_up(paused):
	if paused:
		pause = true
		$queue_free_timer.paused = true
	else:
		pause = false
		$queue_free_timer.paused = false
