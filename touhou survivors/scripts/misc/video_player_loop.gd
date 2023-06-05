extends VideoStreamPlayer


func _ready():
	self.connect("finished",on_finished)
	self.set_process(false)
	self.set_physics_process(false)

func on_finished():
	play()
