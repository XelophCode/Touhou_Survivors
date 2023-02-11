extends item_base_class

@onready var slash_1 = $main_body/animations/slash1
@onready var slash_2 = $main_body/animations/slash2
@onready var slash_3 = $main_body/animations/slash3
@onready var animation_player = $AnimationPlayer

var size_mod:float = 1

func _ready():
	damage = 1
	rotation = deg_to_rad(randi_range(0,359))
	slash_1.visible = true
	slash_1.play("slash")
	animation_player.play("slash1")
	size_mod = 2.0
	$main_body.scale.x = size_mod
	$main_body.scale.y = size_mod

func _process(_delta):
	global_position = Globals.player_position
	if slash_3.frame == 5:
		visible = false

func _on_slash_1_animation_finished():
	slash_1.visible = false
	if occult_orb:
		damage = 2
		slash_2.visible = true
		slash_2.play("slash")
		animation_player.play("slash2")
	else:
		queue_free()

func _on_slash_2_animation_finished():
	slash_2.visible = false
	damage = 3
	slash_3.visible = true
	slash_3.play("slash")
	animation_player.play("slash3")

func _on_slash_3_animation_finished():
	queue_free()

func _on_hitbox_1_body_entered(body):
	do_damage(body)

func _on_hitbox_2_body_entered(body):
	do_damage(body)

func _on_hitbox_3_body_entered(body):
	do_damage(body)
