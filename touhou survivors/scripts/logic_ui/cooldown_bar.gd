extends TextureProgressBar
var timer_id:int
var timer

func _ready():
	if visible:
		timer = instance_from_id(timer_id)

func _process(_delta):
	if visible:
		max_value = timer.get_wait_time()
		value = timer.get_time_left()
