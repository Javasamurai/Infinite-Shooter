extends Node2D

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
export(NodePath) var health_label

signal hit

func _ready():
	set_process(true)
	screenBounds = get_viewport_rect().size
	enemy_list = []
	enemy = preload("res://Nodes/Enemy.tscn")
	player = preload("res://Nodes/Player.tscn")
	$Player.connect("hit",self, "on_player_hit")

func _process(delta):
	time_elapsed+=delta
	if time_elapsed > spawnDelay:
		canSpawn = true
		spawnEnemies()
		time_elapsed = 0
	pass

func _input(event):
	if event is InputEventScreenDrag:
		return
		temp_position = event.get("position")
		if $Player != null:
			if temp_position.x > last_position.x:
				$Player.movement($Player.DIRECTION.RIGHT)
			elif temp_position.x < last_position.x:
				$Player.movement($Player.DIRECTION.LEFT)
			elif temp_position.y < last_position.y:
				$Player.movement($Player.DIRECTION.UP)
			elif temp_position.y > last_position.y:
				$Player.movement($Player.DIRECTION.DOWN)
			last_position = temp_position
	pass

func on_player_hit():
	get_node(health_label).set_text(str($Player.health))
	pass
func spawnEnemies():
	# check current enemies
	var enemy_counter = 0

	if $enemy_container.get_child_count() <= max_enemies && canSpawn:

		enemy_counter = enemy_counter + 1
		var enemy_clone = enemy.instance()
		
		enemy_clone.position = Vector2(rand_range(-screenBounds.x / 2 + enemy_clone.texture.get_size().x / 2, screenBounds.x / 2- enemy_clone.texture.get_size().x / 2), -(screenBounds.y / 2) + enemy_clone.texture.get_size().y)
		$enemy_container.add_child(enemy_clone)
	pass


func _on_speed_changed():
	pass
