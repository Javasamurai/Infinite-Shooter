extends Sprite

var time_elapsed
var speed = 120
var powerup_names = {
	1: "minify",
	2: "sonic_boom",
	3: "potion"
}
var powerup


func _ready():
	set_process(true)
	time_elapsed = 0
	powerup = powerup_names[int(rand_range(0, 3))]
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
