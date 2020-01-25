extends Node

var player
var enemy
var enemy_list = []
var max_enemies = 5
var time_elapsed = 0
var canSpawn = true
var spawnDelay = 1
var screenBounds = Vector2.ZERO
var last_position = Vector2.ZERO
var temp_position = Vector2.ZERO

func _ready():
	set_process(true)
	screenBounds = Vector2(get_viewport().size.x, get_viewport().size.y)
	enemy_list = []
	enemy = preload("res://Enemy.tscn")
	player = preload("res://Player.tscn")
	
func _process(delta):
	time_elapsed+=delta
	if time_elapsed > spawnDelay:
		canSpawn = true
		spawnEnemies()
		time_elapsed = 0
	pass

func _input(event):
	if event is InputEventScreenDrag:
		print("Dragging")
		last_position = event.get("position")
		print(event.get("position"))
	pass

func spawnEnemies():
	# check current enemies
	if enemy_list.size() < max_enemies && canSpawn:
		var enemy_clone = enemy.instance()
		enemy_clone.position = Vector2(rand_range(100, screenBounds.x - 100) / 2, 0)
		self.add_child(enemy_clone)
		enemy_list.insert(enemy_list.size(), enemy_clone)
	pass