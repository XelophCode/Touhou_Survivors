extends item_base_class

func _ready():
	damage = 1
	global_position = Globals.player_position
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	$AnimationPlayer.play("throw")
	$main_body/KnifeThrow.visible = true
	if occult_orb:
		$main_body/KnifeThrow2.visible = true; $main_body/KnifeThrow3.visible = true
	

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
