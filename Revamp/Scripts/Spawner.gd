extends Node2D

export var spawnDelay = 1

func _ready():
	yield(get_tree().create_timer(spawnDelay),"timeout")
	for	enemy in get_children():
		enemy.active = true
	pass
