extends AnimatedSprite

signal powerup_cleared

var time_elapsed
var speed = 120
onready var powerup_names = {
	1: "Minify",
	2: "sonic boom",
	3: "potion",
	4: "shield",
	5: "Coins",
	6: "coins crate",
	7: "Machine gun"
}

var powerup = null
func _ready():
	randomize()
	powerup = powerup_names[1]
	set_process(true)
	time_elapsed = 0
	var random_int = randi()
	powerup = powerup_names[random_int % powerup_names.size() + 1]
	play(powerup)
	pass

func _process(delta):
	time_elapsed+=delta
	position.y = (position.y) + (speed * delta)
	pass

func _on_VisibilityNotifier2D_screen_exited():
	#emit_signal("powerup_cleared")
	queue_free()
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	#emit_signal("powerup_cleared")
	queue_free()
	pass
