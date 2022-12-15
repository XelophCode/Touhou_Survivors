extends Camera2D

@onready var shop = preload("res://prefabs/logic_ui/shop.tscn")
@onready var inventory = preload("res://prefabs/logic_ui/Inventory.tscn")
@onready var shop_close_button = preload("res://prefabs/logic_ui/shop_close_button.tscn")

var max_power:float = 1
var power:float

func _ready():
	Signals.connect("update_power",update_power)

func _physics_process(_delta):
	global_position = Globals.player_position
	$Powerbar.value = power
	$Powerbar.max_value = max_power
	if power >= max_power:
		open_inventory()

func open_inventory():
	$Inventory.open_inventory()
	$Shop.open_shop()
	var new_close_button = shop_close_button.instantiate()
	new_close_button.global_position += Vector2(-100,102)
	add_child(new_close_button)
	max_power *= 1.5
	max_power = ceil(max_power)
	power = 0
	Signals.emit_signal("leveling_up",true)
	Globals.leveling_up = true

func update_power(value:float):
	power += value
