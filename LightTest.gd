extends Sprite


func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton || event is InputEventScreenDrag:
		self.position = event.position
	pass

func _process(delta):
	pass
