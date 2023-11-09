extends Area2D

@export var blocked_space_images : blocked_space_images
@export var click_detection : Area2D

var blocked:bool = false
var hovering_blocked_space : bool = false

func _ready():
	$BlockedSpace.texture = blocked_space_images.images.pick_random()
	Signals.connect("show_blocked_spaces",catch_show_blocked_spaces)
	Signals.connect("leveling_up",catch_leveling_up)
	Signals.fade_ui.connect(catch_fade_ui)
	
	click_detection.area_entered.connect(func(area):
		if "collision_id" in area.owner:
			if area.owner.collision_id.collision_id == "cursor":
				if $BlockedSpace.visible == true and !Globals.holding_item:
					$BlockedSpace.material.set_shader_parameter("flash_modifier",0.3)
					hovering_blocked_space = true
					Signals.show_interact_prompt.emit(true)
					)
	click_detection.area_exited.connect(func(area):
		if "collision_id" in area.owner:
			if area.owner.collision_id.collision_id == "cursor":
				if $BlockedSpace.visible == true and !Globals.holding_item:
					$BlockedSpace.material.set_shader_parameter("flash_modifier",0)
					hovering_blocked_space = false
					Signals.show_interact_prompt.emit(false)
					)


func _process(delta):
	if hovering_blocked_space:
		if !Globals.holding_item:
			if Input.is_action_just_pressed("left_mouse_button") or Input.is_action_just_pressed("a_button_press"):
				if blocked:
					if Globals.crystal_count > 0:
						Signals.show_interact_prompt.emit(false)
						Signals.emit_signal("remove_blocked_space_sfx")
						$AnimationPlayer.play("blocked_space_dissolve")
						monitorable = true
						monitoring = true
						Signals.emit_signal("show_hand_cursor",false)
#						Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
						Globals.crystal_count -= 1.0
						Signals.emit_signal("decrease_crystal_count")
						blocked = false
					else:
						Signals.emit_signal("not_enough_crystals")


func catch_show_blocked_spaces():
	if blocked:
		$BlockedSpace.visible = true
		$AnimationPlayer.play("show_blocked")

func catch_leveling_up(value):
	if !value:
		$BlockedSpace.visible = false
		hovering_blocked_space = false
	else:
		$AnimationPlayer2.play("fade_in")

func blocked_space_invisible():
	$BlockedSpace.visible = false

func catch_fade_ui(fade):
	if fade:
		$AnimationPlayer2.play("fade_out")
	else:
		$AnimationPlayer2.play("fade_in")
