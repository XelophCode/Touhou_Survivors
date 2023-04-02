extends Resource
class_name InventoryItemResource

@export var enabled : bool = true

@export_enum("Yinyang Orb","Sake","Gohei","Roukanken","Throwing Knife","Rock","Magic Broom","Mini Hakkero",\
"Homing Amulet","Frog","Haniwa","Camera","Miracle Mallet","Persuasion Needles","Icicle","Youkai Umbrella",\
"Purification Rod","Mochi Mallet","Magic Bomb","Shanghai Doll","Bat","Keystone","Gap Umbrella","Magic Tome",\
"Nature Wand","Mushroom","Megaphone Gun","Lunar Bow")\
var item_name

var name : Array = ["Yinyang Orb","Sake","Gohei","Roukanken","Throwing Knife","Rock","Magic Broom","Mini Hakkero",\
"Homing Amulet","Frog","Haniwa","Camera","Miracle Mallet","Persuasion Needles","Icicle","Youkai Umbrella",\
"Purification Rod","Mochi Mallet","Magic Bomb","Shanghai Doll","Bat","Keystone","Gap Umbrella","Magic Tome",\
"Nature Wand","Mushroom","Megaphone Gun","Lunar Bow"]

@export_multiline var description = ""
@export_enum("1x1","1x2","1x3","2x2","2x3") var inventory_size
@export var inventory : PackedScene
@export var spawnable : PackedScene
@export var icon : Texture
@export var active : bool = true
@export var cooldown : int
@export var one_time_spawn : bool = false
@export var item_set:Array[int]
@export var spell_card:SpellCardResource
