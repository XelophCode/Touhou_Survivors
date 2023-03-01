extends item_base_class

var size_1:float = 62.0
var size_2:float = 37.0
var wm:float = Globals.wind_mult()
var wd:float = Globals.wind_div()
var width:float
var height:float
var enemies_to_damage:Array = []
var img
@export var photo : PackedScene
var start : Vector2

func _ready():
	$AnimationPlayer.play("fade_in")
	$AnimationPlayer2.play("shrink")
	global_position = Globals.player_position
	
	scale.x = 0.5;scale.y = 0.5
	
	damage = 3
	
	if alt_fire:
		width = size_1
		height = size_2
		
	else:
		width = size_2
		height = size_1
		$main_body.rotation_degrees += 90
	
	start = $pos.global_position
	img = get_viewport().get_texture().get_image()
	rotation = deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing))
	
	


func _process(delta):
	global_position = Globals.player_position
	rotation = lerp_angle(rotation, deg_to_rad(Globals.cardinal_direction_to_rotation(Globals.player_facing)), delta * 4)
	if rotation_degrees < -360:
		rotation_degrees = rotation_degrees - -360
	if rotation_degrees > 360:
		rotation_degrees = rotation_degrees - 360

func delete():
	create_photo()
	for enemy in enemies_to_damage:
		do_damage(enemy)
	queue_free()
	

func camera_flash():
	
	
	$Flash.visible = true
	$Flash.play("default")

func hide_camera_frame():
	$main_body/Sprite2D.visible = false

func create_photo():
	var posneg:float
	if $pos.global_position.y > start.y:
		posneg = -1.0
	else:
		posneg = 1.0
	var diff = Vector2(abs((start.x - $pos.global_position.x)),abs((start.y - $pos.global_position.y)))
	var wid:float
	var heig:float
	var rot_y_sub:float
	var photo_border_rot:float
	var photo_rot:float
	var rot_deg:float
	
	if rotation_degrees > 0:
		rot_deg = (360 - rotation_degrees) * -1
	else:
		rot_deg = rotation_degrees
	
	if rot_deg < 0:
		photo_rot = rot_deg
		if rot_deg < -44:
			photo_rot = abs(-90 - rot_deg)
			if rot_deg < -90:
				photo_rot = rot_deg - -90
				if rot_deg < -134:
					photo_rot = abs(-180 - rot_deg)
					if rot_deg < -180:
						photo_rot = rot_deg - -180
						if rot_deg < -226:
							photo_rot = abs(-270 - rot_deg)
							if rot_deg < -270:
								photo_rot = rot_deg - -270
								if rot_deg < -316:
									photo_rot = abs(-360 - rot_deg)
	
	match abs(snapped(rad_to_deg(rotation),90)):
		0: wid = width; heig = height
		90: wid = height; heig = width; rot_y_sub = 17; photo_border_rot = 90
		180: wid = width; heig = height;
		270: wid = height; heig = width; rot_y_sub = 17; photo_border_rot = 90
		360: wid = width; heig = height
	
	img = img.get_region(Rect2(((235 - diff.x))*wm,((105 - ((diff.y*posneg) + rot_y_sub)))*wm,wid*wm,heig*wm))
	
	var inst = photo.instantiate()
	var tex = ImageTexture.create_from_image(img)
	inst.photo_texture.texture = tex
	inst.global_position = $main_body/Sprite2D.global_position
	inst.z_index = 100
	inst.photo_texture.scale = Vector2(wd,wd)
	inst.photo_border.rotation = deg_to_rad(photo_border_rot)
	inst.rotation_degrees = photo_rot
	inst.alt = !alt_fire
	get_parent().get_parent().add_child(inst)

func _on_area_2d_body_entered(body):
	enemies_to_damage.append(body)

func _on_area_2d_body_exited(body):
	enemies_to_damage.erase(body)

func _on_flash_animation_finished():
	$Flash.visible = false
