extends Sprite

var time_elapsed
var speed = 120
func _ready():
	set_process(true)
	time_elapsed = 0
	pass

func _process(delta):
	time_elapsed+=delta
	position.y = (position.y) + (speed * delta)
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
	pass
