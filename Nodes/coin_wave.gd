extends Node2D

var started = false
func _ready():
	set_process(true)
	pass

func _process(delta):
	if started == true:
		position.y +=(250 * delta)
	pass

func got_coin():
	print("Got coin")
	pass

func start_wave():
	started = true
	visible = true
	position = Vector2.ZERO
	pass

func reset_wave():
	started = false
	position = Vector2.ZERO
	visible = false
	queue_free()
	pass
