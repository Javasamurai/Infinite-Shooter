extends Camera2D

var player
var enemy
var powerup_node
var powerup_container
var powerup_clone
var enemy_list = []
var max_enemies = 5
var time_elapsed = 0
var powerup_spawn_delay = 7
var isPowerSpawned = false
var canSpawn = true
var spawnDelay = 1
var last_spawned_time
var screenBounds = Vector2.ZERO
var last_position = Vector2.ZERO
var temp_position = Vector2.ZERO
var rng
var score = 0
var announcement_lbl
var announcement_panel
var tween
var timer

export(NodePath) var health_label
export(NodePath) var score_label
export(NodePath) var health_sprite
export(NodePath) var announcement_lbl_path
export(NodePath) var announcement_panel_path

signal hit

func _ready():
	tween = get_node("Tween")
	timer = get_node("Timer")
	rng = RandomNumberGenerator.new()
	rng.randomize()
	set_process(true)
	screenBounds = get_viewport_rect().size
	enemy_list = []
	last_spawned_time = 0
	enemy = preload("res://Nodes/Enemy.tscn")
	player = preload("res://Nodes/Player.tscn")
	powerup_node = preload("res://Nodes/powerup.tscn")
	$Player.connect("hit",self, "on_player_hit")
	powerup_container = $powerup_container
	announcement_lbl = get_node(announcement_lbl_path)
	announcement_panel = get_node(announcement_panel_path)

func _process(delta):
	time_elapsed+=delta
	last_spawned_time+= delta

	if time_elapsed > 0.25:
		for i in range($enemy_container.get_child_count()):
			var enemy = $enemy_container.get_child(i)

			#if enemy.smart:
			enemy.move_to($Player.position)
			
	if last_spawned_time > spawnDelay:
		last_spawned_time = 0
		canSpawn = true
		spawnEnemies()

	if (int(time_elapsed) % powerup_spawn_delay) == 0 and powerup_container.get_child_count() == 0 and time_elapsed > 0:
		isPowerSpawned = true
		spawnPowerup()
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

func enemy_hit(which_one):
	score += 100
	get_node(score_label).text = "Score:" + str(score) 

func on_player_hit():
	get_node(health_label).set_text(str($Player.health))
	$ScreenShake.shake(0.75, 1000, 5)
	pass
	
func spawnPowerup():

	isPowerSpawned = true
	powerup_clone = powerup_node.instance()
	var collision_area = powerup_clone.find_node("powerup_area")
	collision_area.connect("area_entered", self ,"_on_powerup_got")
	powerup_clone.position = Vector2(rand_range(-screenBounds.x / 2, screenBounds.x / 2), -(screenBounds.y / 2))
	powerup_container.add_child(powerup_clone)
	pass

func _on_powerup_got(areas):
	if areas.name == "bullet_area":
		#var which_one = "sonic_boom" if rng.randf_range(0, 1) < 0.5 else "minify"
		var which_one = powerup_clone.get_node("powerup_animated").powerup
		announcement_panel.visible = true
		announcement_lbl.text = which_one
		
		tween.interpolate_property(announcement_lbl, "margin_left",250, -55,0.5,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
		tween.interpolate_property(announcement_lbl, "modulate", Color.transparent,Color.white,2,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
		tween.start()

		if which_one == "potion":
			$health.play()
		else:
			$powerup.play()
		$Player.powerup(which_one)
		powerup_clone.queue_free()

func spawnEnemies():
	# check current enemies
	var enemy_counter = 0

	if $enemy_container.get_child_count() <= max_enemies && canSpawn:
		enemy_counter = enemy_counter + 1
		var enemy_clone = enemy.instance()
		var texture = enemy_clone.get_sprite_frames().get_frame("1", 0)

		enemy_clone.position = Vector2(rand_range(-screenBounds.x / 2 + texture.get_size().x / 2, screenBounds.x / 2- texture.get_size().x / 2), -(screenBounds.y / 2) + texture.get_size().y)
		$enemy_container.add_child(enemy_clone)
		
		enemy_clone.connect("enemy_hit", self, "enemy_hit")
		if enemy_clone.smart:
			enemy_clone.move_to($Player.position)
	pass


func _on_speed_changed():
	pass


func _on_Tween_tween_completed(object, key):
	#print(key)
	#if key == "margin_left":
	#	announcement_panel.visible = false
	pass


func _on_Tween_tween_all_completed():
	announcement_panel.visible = false
	pass
