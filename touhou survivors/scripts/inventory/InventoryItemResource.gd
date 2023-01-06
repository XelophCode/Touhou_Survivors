extends Resource
class_name InventoryItemResource

@export var enabled : bool = true

@export_enum("Yinyang Orb","Sake","Gohei","Roukanken","Throwing Knife","Rock","Magic Broom","Mini Hakkero",\
"Homing Amulet","Frog","Haniwa","Camera","Miracle Mallet","Persuasion Needles","Icicle","Youkai Umbrella",\
"Purification Rod","Mochi Mallet","Magic Bomb","Shanghai Doll","Bat") \
var item_name

var name : Array = ["Yinyang Orb","Sake","Gohei","Roukanken","Throwing Knife","Rock","Magic Broom","Mini Hakkero",\
"Homing Amulet","Frog","Haniwa","Camera","Miracle Mallet","Persuasion Needles","Icicle","Youkai Umbrella",\
"Purification Rod","Mochi Mallet","Magic Bomb","Shanghai Doll","Bat"]

@export_multiline var description = ""
@export_enum("1x1","1x2","1x3","2x2","2x3") var inventory_size
@export var inventory : PackedScene
@export var spawnable : PackedScene
@export var icon : Texture
@export var active : bool = true
@export var cooldown : int
@export var stack_limit : int
