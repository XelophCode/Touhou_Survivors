extends item_base_class

func _ready():
	damage = 1
	global_position = Globals.player_position
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	$AnimationPlayer.play("throw")
	$main_body/KnifeThrow.visible = true
	match stack_count:
		1: pass
		2: $main_body/KnifeThrow2.visible = true
		3: $main_body/KnifeThrow2.visible = true; $main_body/KnifeThrow3.visible = true
		_: print("ERROR: THROWINGKNIFE OUT OF STACK RANGE, COUNT: " + str(stack_count))

func delete():
	queue_free()

func _on_1_body_entered(body):
	if $main_body/KnifeThrow.visible == true:
		do_damage(body)

func _on_k_2_body_entered(body):
	if $main_body/KnifeThrow2.visible == true:
		do_damage(body)

func _on_k_3_body_entered(body):
	if $main_body/KnifeThrow3.visible == true:
		do_damage(body)
