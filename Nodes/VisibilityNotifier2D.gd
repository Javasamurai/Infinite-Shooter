extends VisibilityNotifier2D

export var speed = 75

func _ready():
	#connect("screen_exited", $"../", "WaveDone")
	#connect("viewport_exited", $"../", "WaveDone")
	set_process(true)

func _process(delta):
	position.y = (position.y  + speed * delta)
	pass
