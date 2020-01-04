extends ParallaxLayer

export var speed = 3

func _ready():
	set_process(true)
	pass
func _process(delta):
	motion_offset.y+=speed
	pass
