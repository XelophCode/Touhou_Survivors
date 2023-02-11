extends Camera2D

@onready var shop = preload("res://prefabs/logic_ui/shop.tscn")
@onready var inventory = preload("res://prefabs/logic_ui/Inventory.tscn")
@onready var shop_close_button = preload("res://prefabs/logic_ui/shop_close_button.tscn")

var camera_is_tweening:bool = false
var camera_gap_pos:Vector2
var level:int = 1
var play_time_second:float
var play_time_minute:int
var power_lerp:float
var leveling_up:bool = false

func _ready():
	Signals.connect("leveling_up",catch_leveling_up)
	Signals.connect("gap_camera_tween",gap_camera_tween)
	
#	for child in $OccultOrbParent.get_children():
#		child.get_child(1).max_value = Globals.occult_orb_max

func _process(delta):
	if camera_is_tweening:
		global_position = lerp(global_position,camera_gap_pos,delta * 8)
		if global_position.distance_to(camera_gap_pos) < 0.5:
			gap_finish()
	else:
#		global_position.x = snappedf(global_position.x,0.1)
#		global_position.y = snappedf(global_position.y,0.1)
		global_position.x = lerp(global_position.x,Globals.player_position.x,delta*4)
		global_position.y = lerp(global_position.y,Globals.player_position.y,delta*4)

func open_inventory():
	level += 1
	match level:
		5: $Inventory.current_tier = $Inventory.tier_two; $Inventory.get_node("ReimuInventoryGrid/BlockedSpaces").texture = $Inventory.blocked_spaces_tier_2
		10: $Inventory.current_tier = $Inventory.tier_three; $Inventory.get_node("ReimuInventoryGrid/BlockedSpaces").texture = $Inventory.blocked_spaces_tier_3
		15: $Inventory.current_tier = $Inventory.tier_four; $Inventory.get_node("ReimuInventoryGrid/BlockedSpaces").texture = $Inventory.blocked_spaces_tier_4
		20: $Inventory.current_tier = $Inventory.tier_five; $Inventory.get_node("ReimuInventoryGrid/BlockedSpaces").visible = false
		_:pass
	$Inventory.open_inventory()
	$Shop.open_shop()

func catch_leveling_up(value):
	leveling_up = value
	if value:
		open_inventory()
		$shop_close_button.visible = true
		$ScreenDim.visible = true
		$AnimationPlayer.play("screen_dim")
	else:
		$ScreenDim.visible = false

func gap_camera_tween(destination:Vector2):
	camera_is_tweening = true
	camera_gap_pos = destination

func gap_finish():
	Signals.emit_signal("gap_finish")
	camera_is_tweening = false

func _on_button_button_down():
	Signals.emit_signal("leveling_up",false)
	$shop_close_button.visible = false
