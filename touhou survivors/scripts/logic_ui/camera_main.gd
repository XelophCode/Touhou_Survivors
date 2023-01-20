extends Camera2D

@onready var shop = preload("res://prefabs/logic_ui/shop.tscn")
@onready var inventory = preload("res://prefabs/logic_ui/Inventory.tscn")
@onready var shop_close_button = preload("res://prefabs/logic_ui/shop_close_button.tscn")

var max_power:float = 1
var power:float
var camera_is_tweening:bool = false
var camera_gap_pos:Vector2

func _ready():
	Signals.connect("update_power",update_power)
	Signals.connect("leveling_up",leveling_up)
	Signals.connect("gap_camera_tween",gap_camera_tween)
	Signals.connect("player_damaged",damage_animation)

func _physics_process(delta):
	if !camera_is_tweening:
		global_position = Globals.player_position
	else:
		global_position = lerp(global_position,camera_gap_pos,delta * 8)
		$Powerbar.position = Vector2(-211,-119)
		$PowerbarBorder.position = Vector2(0,-112)
		if global_position.distance_to(camera_gap_pos) < 0.5:
			gap_finish()
	$Powerbar.value = power
	$Powerbar.max_value = max_power
	if power >= max_power:
		open_inventory()

func open_inventory():
	$Inventory.open_inventory()
	$Shop.open_shop()
#	var new_close_button = shop_close_button.instantiate()
#	new_close_button.global_position += Vector2(-100,102)
#	add_child(new_close_button)
	max_power *= 1.5
	max_power = ceil(max_power)
	power = 0
	Signals.emit_signal("leveling_up",true)
	Globals.leveling_up = true

func update_power(value:float):
	power += value

func leveling_up(value):
	if value:
		$shop_close_button.visible = true
		$Timer.stop()
		$ReimuPortrait.play("smile")
		$ScreenDim.visible = true
		$AnimationPlayer.play("screen_dim")
	else:
		$Timer.start()
		$ReimuPortrait.play("head_bob")
		$ScreenDim.visible = false

func gap_camera_tween(destination:Vector2):
	camera_is_tweening = true
	camera_gap_pos = destination

func gap_finish():
	Signals.emit_signal("gap_finish")
	camera_is_tweening = false


func _on_reimu_portrait_animation_finished():
	$ReimuPortrait.stop()
	if $ReimuPortrait.animation == "head_bob":
		$ReimuPortrait.frame = 0
	if $ReimuPortrait.animation == "smile":
		$ReimuPortrait.frame = 3
	if $ReimuPortrait.animation == "damage":
		$ReimuPortrait.frame = 0
	if $ReimuPortrait.animation == "blink":
		$ReimuPortrait.frame = 0

func _on_timer_timeout():
	var random_anim:Array = ["head_bob","blink"]
	$ReimuPortrait.play(random_anim.pick_random())

func damage_animation():
	$ReimuPortrait.play("damage")


func _on_button_button_down():
	Globals.leveling_up = false
	Signals.emit_signal("leveling_up",false)
	$shop_close_button.visible = false
