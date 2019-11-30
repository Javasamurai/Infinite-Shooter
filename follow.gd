extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass
func _process(delta):
	self.position= Vector2(self.position.x + 2, self.position.y)
	print(self.position)
	pass
