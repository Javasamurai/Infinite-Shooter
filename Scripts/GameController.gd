extends Camera2D

var player
var enemy
var powerup_node
var powerup_container
var powerup_clone
var enemy_list = []
var max_enemies = 5
var time_elapsed = 0
var powerup_spawn_delay = 5
var isPowerSpawned = false
var canSpawn = true
var spawnDelay = 5
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
var coin_wave_node
var score_path = "user://score.txt"

var current_wave = 1
var powerup_enengy
var powerup_timer
var time_passed_since_powerup = 0

export(NodePath) var health_label
export(NodePath) var score_label
export(NodePath) var health_sprite
export(NodePath) var announcement_lbl_path
export(NodePath) var announcement_panel_path

signal hit

func _ready():
	tween = get_node("Tween")
	timer = get_node("Timer")
	powerup_enengy = get_node("Control/PowerupEnergy")
	powerup_timer = powerup_enengy.get_node("powerup_timer")
	powerup_enengy.percent_visible = true
	powerup_enengy.set_percent_visible(100)
	rng = RandomNumberGenerator.new()
	rng.randomize()
	set_process(true)
	screenBounds = get_viewport_rect().size
	enemy_list = []
	last_spawned_time = 0
	enemy = preload("res://Nodes/Enemy.tscn")
	player = preload("res://Nodes/Player.tscn")
	coin_wave_node = get_node("coin_wave")
	#coin_wave_node = preload("res://Nodes/coin_wave.tscn")

	powerup_node = preload("res://Nodes/powerup.tscn")
	$Player.connect("hit",self, "on_player_hit")
	$Player.connect("player_die", self, "save_score", [score])
	powerup_container = $powerup_container
	announcement_lbl = get_node(announcement_lbl_path)
	announcement_panel = get_node(announcement_panel_path)
	announce_something("WAVE " + str(current_wave))

	#announce_something("In a galaxy far far away. There was a gladiator.", 5)
func _process(delta):
	time_elapsed+=delta
	last_spawned_time+= delta

	#if time_elapsed > 2:
	for i in range($enemy_container.get_child_count()):
		var enemy = $enemy_container.get_child(i)

		#if enemy.smart:
		enemy.move_to($Player.position)

	if last_spawned_time > spawnDelay:
		last_spawned_time = 0
		canSpawn = true
		spawnEnemiesWAVE1()

# Wave generation logic

func check_powerup():
	if (powerup_container.get_child_count() == 0 and !isPowerSpawned):
		timer.start()
		var random_gen = randi() % powerup_spawn_delay + 3

		if int(time_elapsed) % random_gen == 0: 
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

func check_wave():
	var coin_range = range(100, 3000, 200)
	var waves = {
		1: 100,
		2: 200,
		3: 300,
		4: 400,
		5: 500,
		6: 700
	}
	#var score_range = waves[current_wave]
	if score > current_wave * 100:
	#if score > waves[current_wave]:
		current_wave = current_wave + 1
		announce_something("WAVE" + str(current_wave))
		if spawnDelay > 0.1:
			spawnDelay = spawnDelay - 0.5
		#spawnEnemiesWAVE1()

	match score:
		coin_range: coin_wave()
	pass
	
func coin_wave():
	coin_wave_node.visible = true
	# all powerup and enemies destroy
	if powerup_clone!=null:
		powerup_clone.queue_free()

	for n in $enemy_container.get_children():
		$enemy_container.remove_child(n)
		n.queue_free()

	coin_wave_node.start_wave()
	pass
func enemy_hit(which_one):
	score += 200
	$ScreenShake.shake(0.75, 500, 5)
	get_node(score_label).text = "Score:" + str(score) 
	check_wave()

func on_player_hit():
	get_node(health_label).set_text(str($Player.health))
	$ScreenShake.shake(0.75, 1000, 5)
	pass
	
func spawnPowerup():
	isPowerSpawned = true
	powerup_clone = powerup_node.instance()
	var powerup_node = powerup_clone.get_node("powerup_animated")
	powerup_node.connect("powerup_cleared", self, "powerup_cleared")
	var collision_area = powerup_clone.find_node("powerup_area")
	collision_area.connect("area_entered", self ,"_on_powerup_got")
	powerup_clone.position = Vector2(rand_range(-screenBounds.x / 2, screenBounds.x / 2), -(screenBounds.y / 2))
	powerup_container.add_child(powerup_clone)
	pass

func powerup_cleared():
	isPowerSpawned = false
	time_passed_since_powerup = 0
	powerup_enengy.visible = false
	pass

func announce_something(what, time = 2):
	announcement_panel.visible = true
	announcement_lbl.text = what
	tween.interpolate_property(announcement_lbl, "margin_left",250, -119,0.5,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.interpolate_property(announcement_lbl, "modulate", Color.transparent,Color.white,time,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	
	pass

func _on_powerup_got(areas):
	if areas.name == "bullet_area" and powerup_clone != null:
		#var which_one = "sonic_boom" if rng.randf_range(0, 1) < 0.5 else "minify"
		var which_one = powerup_clone.get_node("powerup_animated").powerup
		announce_something(which_one)

		isPowerSpawned = false

		if which_one == "potion":
			$health.play()
		else:
			time_passed_since_powerup = 0
			powerup_enengy.visible = true
			powerup_enengy.value = 100
			powerup_timer.start()
			$powerup.play()
		$Player.powerup(which_one)
		powerup_clone.queue_free()
		powerup_clone = null

func spawnEnemiesWAVE1():
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

func _on_Tween_tween_all_completed():
	announcement_panel.visible = false
	pass

func _on_powerup_timer_timeout():
	time_passed_since_powerup = time_passed_since_powerup + powerup_timer.wait_time
	powerup_enengy.value = 100 - (time_passed_since_powerup / $Player.get_node("./Timer").wait_time) * 100
	pass
	
func load_score():
	var f = File.new()
	var curr_score = 0
	if f.file_exists(score_path):
		f.open(score_path, File.READ)
		curr_score = int(f.get_as_text())
		f.close()
	return curr_score
	pass

func save_score(score = null):
	var f = File.new()
	f.open(score_path, File.WRITE)

	var curr_score = load_score()

	if score > curr_score:
		f.store_string(str(score))
		f.close()
	pass
