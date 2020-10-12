extends Node2D

var global
var currTime = 0
var startTime = 0
var canStart = false

func _ready():
	startTime = rand_range(0, 5.0)
	global = get_node("/root/Globals")
	set_process(true)
	position.x = rand_range(241, 300)
	position.y = rand_range(-50, 100)
	rotation_degrees = -78
	pass

func _process(delta):
	currTime = currTime + delta

	if currTime > startTime:
		startTime = rand_range(0, 5)
		canStart = true

	if !canStart:
		return
	if position.y < global.screen_height && position.y > 0:
		position.x = (position.x - 1 * delta * 100)
		
	elif position.y > rand_range(1000, 2000):
		position.y = rand_range(-50, 100)
		position.x = rand_range(10, global.screen_width - 10)
	
	position.y = (position.y + 1 * delta * 100)
pass
