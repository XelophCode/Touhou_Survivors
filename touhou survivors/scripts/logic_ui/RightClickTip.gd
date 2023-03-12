extends Node2D

var can_shake_anim:bool = true

func _ready():
	Signals.connect("show_right_click_tip",catch_show_right_click_tip)
	Signals.connect("not_enough_crystals",catch_not_enough_crystals)
	Signals.connect("show_spell_card_right_click",catch_show_spell_card_right_click)
	Signals.connect("show_hand_cursor",catch_show_hand_cursor)

func _process(_delta):
	global_position.x = get_global_mouse_position().x + 2
	global_position.y = get_global_mouse_position().y + 6
	if Globals.holding_item:
		z_index = 200
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		$AnimatedSprite2D.frame = 1
	else:
		z_index = 31
	

func catch_show_right_click_tip(value):
	if !Globals.holding_item:
		visible = value
		$AnimatedSprite2D.play("crystal")

func catch_not_enough_crystals():
	if can_shake_anim:
		$AnimationPlayer.play("shake")

func catch_show_spell_card_right_click(value):
	if !Globals.holding_item:
		visible = value
		can_shake_anim = !value
		$AnimatedSprite2D.play("spell_card")

func catch_show_hand_cursor(value):
	if !Globals.holding_item:
		visible = value
		$AnimatedSprite2D.play("hand")
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0


