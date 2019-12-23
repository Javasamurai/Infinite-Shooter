extends ParallaxLayer

func _ready():
	set_process(true)
	pass
func _process(delta):
	motion_offset.y+=3
	#self.position= Vector2(self.position.x, self.position.y + 2)
	pass
