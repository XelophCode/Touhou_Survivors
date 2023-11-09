extends Node

#@export var initialize_scene : PackedScene
#@export var main_menu_scene : PackedScene
#@export var character_select_scene : PackedScene
#@export var main_game_scene : PackedScene
@export var loading_bar : ProgressBar
@export var transitions : Node2D
@export var anims : AnimationPlayer
@export var fullscreen_pink : Sprite2D
@export var fullscreen_black : Node2D
@export var fullscreen_black_1 : Sprite2D
@export var fullscreen_black_2 : Sprite2D
@export var fullscreen_black_3 : Sprite2D


@export var initialize : String
@export var main_menu : String
@export var character_select : String
@export var main_game : String

var loading : bool = false
var new_scene_path : String
var loading_progress : Array = []


#func _enter_tree():
#	initialize = initialize_scene.resource_path
#	main_menu = main_menu_scene.resource_path
#	character_select = character_select_scene.resource_path
#	main_game = main_game_scene.resource_path
#
#	initialize_scene = null
#	main_menu_scene = null
#	character_select_scene = null
#	main_game_scene = null


func change_scene(entering_scene:String,exiting_scene:Node):
	exiting_scene.tree_exited.connect(start_load.bind(entering_scene))
	exiting_scene.queue_free()


func start_load(scene:String):
	if ResourceLoader.load_threaded_request(scene,"PackedScene") == null:
		print("ERROR LOADED SCENE NULL")
		get_tree().quit()
		return
	
	match scene:
		character_select:
			$CanvasLayer/transitions/loading_bar.hide()
			fullscreen_pink.show()
			fullscreen_pink.material.set_shader_parameter("dissolve_value",1.0)
		main_game:
			$CanvasLayer/transitions/loading_bar.hide()
			fullscreen_black_3.show()
			fullscreen_black.show()
			fullscreen_black_1.position = Vector2(0,-120)
			fullscreen_black_2.position = Vector2(0,120)
		main_menu:
			$CanvasLayer/transitions/fullscreen_black_2.show()
	
	transitions.show()
	new_scene_path = scene
	loading = true


func _process(delta):
	if loading:
		var loading_status : int = -1
		loading_status = ResourceLoader.load_threaded_get_status(new_scene_path,loading_progress)
		
		print(str(loading_progress[0]))
		loading_bar.value = loading_progress[0]
		
		
		if loading_status == 3:
			print("LOADING DONE")
			transitions.hide()
			loading = false
			var new_scene_inst = ResourceLoader.load_threaded_get(new_scene_path).instantiate()
			get_tree().get_root().call_deferred("add_child",new_scene_inst)
			
			match new_scene_path:
				character_select:
					anims.play("pink_fade_out")
				main_game:
					anims.play("black_slide_out")
				main_menu:
					$CanvasLayer/transitions/fullscreen_black_2.hide()
			
			new_scene_inst = null
			new_scene_path = ""







