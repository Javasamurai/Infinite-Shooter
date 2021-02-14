extends Node2D

export var spawnDelay = 1

func _ready():
	yield(get_tree().create_timer(spawnDelay),"timeout")
	reset()
	pass

func reset():
	for	enemy in get_children():
		enemy.active = true
		#enemy.position.y = -OS.get_real_window_size().y
