extends Node2D

var global
func _ready():
	global = get_node("/root/Globals")
	
	#$Tween.connect("tween_all_completed", self, "startTween")
	#startTween()
	set_process(true)
	
	position.x = rand_range(10, global.screen_width - 10)
	position.y = 500
	rotation = rand_range(30, 90)
	pass
	
func _process(delta):
	if position.y < global.screen_height && position.y > 0:
		position.x = (position.x - 1 * delta * 100)
	elif position.y <= -1000:
		position.y = rand_range(500, 1000)
		position.x = rand_range(10, global.screen_width - 10)
	position.y = (position.y - 1 * delta * 100)
pass
