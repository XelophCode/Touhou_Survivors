extends Camera2D

var camera_is_tweening:bool = false
var camera_gap_pos:Vector2
var leveling_up:bool = false

func _ready():
	Signals.connect("leveling_up",catch_leveling_up)
	Signals.connect("gap_camera_tween",gap_camera_tween)

func _process(delta):
	if camera_is_tweening:
		global_position = lerp(global_position,camera_gap_pos,delta * 8)
		if global_position.distance_to(camera_gap_pos) < 0.5:
			gap_finish()
	else:
		global_position.x = lerp(global_position.x,Globals.player_position.x,delta*4)
		global_position.y = lerp(global_position.y,Globals.player_position.y,delta*4)

func catch_leveling_up(value):
	leveling_up = value
	if leveling_up:
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

