extends CharacterBody2D
class_name enemy_base_class

var direction_to_player:Vector2
var knockback:bool = false
var previous_velocity:Vector2
@export_enum("Tier_0","Tier_1") var tier
@export_enum("Red","Green","Blue") var type
@export var sprite : Node
@export var face_player : bool = false
@export var particles : Node
@export var animation : Node
@export var shadow : Node
var speed_mod = 1.0
var dissolve = 1.0
@export var base_speed : float = 300.0
@export var hp:int = 5
@export var damage:float = 1
var alive : bool = true
