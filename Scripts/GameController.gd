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

var wave_clone
var wave_cooldown = 3
var spawnDelay = 1.5
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

var current_wave = 0
var powerup_enengy
var powerup_timer
var time_passed_since_powerup = 0
var health_progress
var global
var max_enemies_spawn = 1
var fps_lbl

export(NodePath) var health_label
export(NodePath) var score_label
export(NodePath) var health_progress_path
export(NodePath) var announcement_lbl_path
export(NodePath) var announcement_panel_path
export(NodePath) var heart_container_path
export(NodePath) var fps_lbl_path

# warning-ignore:unused_signal
signal got_coin

var coin_range = range(2000, 30000, 2000)
var coin_wave_clone = null
#var crazy_path
#var circular_path
var wave_range = range(4, 3000, 5)

var waves = {
	1: 100,
	2: 800,
	3: 1000,
	4: 1200,
	5: 3000,
	6: 10000,
	7: 15000,
	8: 25000,
	9: 40000,
	10: 55000,
	11: 75000
}

var enemies_waves = {
	1: {
		1: {
			"enemies": 10,
			"delay": 3,
			"random": true
		}
	},
	2: {
		1: {
			"enemies": 10,
			"delay": 1,
			"random": true
		},
		3: {
			"enemies": 10,
			"delay": 3,
			"random": true
		}
	},
	3: {
		1: {
			"enemies": 15,
			"delay": 1,
			"random": true
		},
		3: {
			"enemies": 10,
			"delay": 3,
			"random": true
		}
	},
	4: {
		1: {
			"enemies": 15,
			"delay": 1,
			"random": true
		},
		3: {
			"enemies": 10,
			"delay": 3,
			"random": true
		}
	}
}


var waveSystem = [
	"wave_1",
	"wave_2",
	"wave_3",
	"wave_4",
	"wave_5",
	"wave_6",
	"wave_7",
	"wave_2",
	"wave_2",
	"wave_2",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_6",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_3",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1",
	"wave_1"
]

func _ready():
	global = get_node("/root/Globals")
	#global.saved_data["coins"] = 0
	
	print(global.saved_data["music"])
	
	if global.saved_data["music"]:
		$AudioManager/BGM.play()

	load_score()
	fps_lbl = get_node(fps_lbl_path)
	tween = get_node("Tween")
	timer = get_node("powerup_timer")
	powerup_enengy = get_node("../Control/PowerupEnergy")
	powerup_timer = powerup_enengy.get_node("powerup_timer")
	health_progress = get_node(health_progress_path)
	powerup_enengy.percent_visible = true
	powerup_enengy.set_percent_visible(100)
	rng = RandomNumberGenerator.new()
	rng.randomize()
	set_process(true)
	screenBounds = get_viewport_rect().size
	enemy_list = []
	last_spawned_time = 0
	enemy = preload("res://Nodes/Enemy.tscn")
	player = $Player
	#crazy_path = preload("res://Nodes/spiral_path.tscn")
	#circular_path = preload("res://Nodes/circular_path.tscn")
	coin_wave_node = preload("res://Nodes/coin_wave_linear.tscn")

	powerup_node = preload("res://Nodes/powerup.tscn")
# warning-ignore:return_value_discarded
	$Player.connect("hit",self, "on_player_hit")
# warning-ignore:return_value_discarded
	$Player.connect("player_die", self, "save_score")
	$Player.connect("left", self, "left")
	$Player.connect("right", self, "right")
	EventBus.connect("got_coin", self, "playCoinSound")
	powerup_container = $powerup_container
	global.current_wave = 0
	nextWave()
	pass
	#announce_something("In a galaxy far far away. There was a gladiator.", 5)

func playCoinSound():
	$AudioManager/coin.play()
	pass

func nextWave():
	yield(get_tree().create_timer(1.0), "timeout")
	
	if $"../game_over".visible:
		return
	
	current_wave = current_wave + 1
	announcement_lbl = get_node(announcement_lbl_path)
	announcement_panel = get_node(announcement_panel_path)
	
	var wave1 = load("res://Nodes/" + str(waveSystem[current_wave - 1]) + ".tscn")
	
	if wave_clone != null:
		$".".remove_child(wave_clone)
		wave_clone.queue_free()
	wave_clone = wave1.instance()
	wave_clone.connect("nextWave", self, "nextWave")
	wave_clone.position = Vector2( -screenBounds.x / 2, -screenBounds.y)
	
	$".".add_child(wave_clone)
	
	for i in range(wave_clone.get_child_count()):
		wave_clone.get_child(i).connect("enemy_hit", self, "enemy_hit")
	
	if wave_clone.get_child_count() == 1:
		announce_something("BOSS FIGHT")
	else:
		announce_something("WAVE " + str(current_wave))
pass

func left():
	#$anim.play("left_camera_lerp")
	#tween.interpolate_property(self, "position",self.position,Vector2(-10, 0),0.5,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	#tween.start()
	pass

func right():
	#$anim.play("right_camera_lerp")
	#tween.interpolate_property(self, "position", self.position, Vector2(10, 0),0.5,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	#tween.start()
	pass

func game_over():
	global.saved_data["score"] = score
	global.current_wave = current_wave
	
	$"../game_over".visible = true
	$"../game_over".playing = true
	#global.over = true
	
	pass

func _process(delta):
	
	$ParallaxBackground/ParallaxLayer2/bg.position.x = $Player.position.x / 10

	if Input.is_key_pressed(KEY_ALT):
		$Player.drone(getRandomEnemy(), getRandomEnemy())

	time_elapsed += delta
	last_spawned_time+= delta

	#if time_elapsed > 2:
	if wave_clone != null:
		for i in range(wave_clone.get_child_count()):
			var enemy = wave_clone.get_child(i)
			if enemy is AnimatedSprite:
				enemy.move_to($Player.global_position)

	fps_lbl.text = str(Engine.get_frames_per_second())
	#if last_spawned_time > rand_range(1, spawnDelay):
	#	last_spawned_time = 0
		#canSpawn = true
		
		#if !wave_range.has(current_wave):
		#	spawnEnemiesWAVE1()
		#else:
		#	crazy_wave()

# Wave generation logic

func check_powerup():
	if (powerup_container.get_child_count() == 0):
		timer.start(3)
# warning-ignore:unused_variable
		var random_gen = randi() % powerup_spawn_delay + 3
		
		#spawnPowerup()
		if int(time_elapsed) % random_gen == 0: 
			isPowerSpawned = true
			spawnPowerup()
	pass

func _input(event):
	return
	if event is InputEventScreenDrag:
# warning-ignore:unreachable_code
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
	return
	var score_range = waves[current_wave]
	#if score > current_wave * 100:
	if score > score_range:
		#current_wave = current_wave + 1
		announce_something("WAVE " + str(current_wave))
		
		canSpawn = false
		$wave_timer.start()

		if spawnDelay > 0.1:
			spawnDelay = spawnDelay - 0.1
		#spawnEnemiesWAVE1()
	
	if (coin_range.has(score)) && allEnemiesDead():
		coin_wave()
	pass
	
	
func allEnemiesDead():
	return $enemy_container.get_child_count() == 0
	pass
func coin_removed():
	if coin_wave_clone != null:
		coin_wave_clone = null
	pass

func coin_wave():
	coin_wave_clone = coin_wave_node.instance()
	coin_wave_clone.connect("dead", self, "coin_removed")
	$".".add_child(coin_wave_clone)
	coin_wave_clone.visible = true
	# all powerup and enemies destroy
	if powerup_clone != null:
		powerup_clone.queue_free()
		powerup_clone = null

	for n in $enemy_container.get_children():
		$enemy_container.remove_child(n)
		n.queue_free()

	for n in $crazy_enemies_path.get_children():
		$crazy_enemies_path.remove_child(n)
		n.queue_free()

	coin_wave_clone.start_wave()
	pass
func enemy_hit(which_one):
	if which_one > 4:
		score += 200
	else:
		score += 100
	$ScreenShake.shake(0.75, 250, 2)
	get_node(score_label).text = "Score:" + str(score)
	wave_clone.checkWave()

func on_player_hit():
	get_node(health_label).set_text(str($Player.health))
	$ScreenShake.shake(0.75, 300, 2)
	if $Player.health >=0:
		health_progress.value = int(float($Player.health / 300.0) * 100)
		#health_container.get_child(int($Player.health / 20)).hide()
		$AudioManager/hit.play()
	pass
	
func spawnPowerup():
	isPowerSpawned = true
	powerup_clone = powerup_node.instance()
	var powerup_animated = powerup_clone.get_node("powerup_animated")
	powerup_animated.connect("powerup_cleared", self, "powerup_cleared")
	
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
	announcement_panel.get_node("announcement_anim").play("to_up")
	pass

func _on_powerup_got(areas):
	if areas.name == "bullet_area" && powerup_clone != null:
		#var which_one = "sonic_boom" if rng.randf_range(0, 1) < 0.5 else "minify"
		var which_one = powerup_clone.get_node("powerup_animated").powerup
		
		time_passed_since_powerup = 0
		isPowerSpawned = false
		if which_one == "coins":
			powerup_clone.find_node("coins").visible = true
			coin_wave()
		elif which_one == "potion":
			if global.saved_data["music"]:
				health_progress.value = $Player.health
				$health.play()
		else:
			announce_something(which_one)
			powerup_enengy.visible = true
			powerup_enengy.value = 100
			powerup_clone.queue_free()
			powerup_clone = null
			if global.saved_data["music"]:
				$powerup.play()
		$Player.powerup(which_one)
		powerup_timer.start()
	pass
func spawnEnemiesWAVE1():
	if coin_wave_clone != null:
		return
	randomize()
	# check current enemies
	var enemy_counter = 0

	if $enemy_container.get_child_count() <= max_enemies && canSpawn:
		enemy_counter = enemy_counter + 1
		var enemy_clone = enemy.instance()
		
		enemy_clone.generate_enemy(current_wave)
		var texture = enemy_clone.get_sprite_frames().get_frame("1", 0)

		enemy_clone.position = Vector2(rand_range(-screenBounds.x / 2 + texture.get_size().x / 2, screenBounds.x / 2- texture.get_size().x / 2), -(screenBounds.y / 2) + texture.get_size().y)
		$enemy_container.add_child(enemy_clone)
		enemy_clone.connect("enemy_hit", self, "enemy_hit")
		if enemy_clone.smart:
			enemy_clone.move_to($Player.position)

	pass

func getRandomEnemy():
	var random_enemy = null
	
	if $enemy_container.get_child_count() > 0:
		randomize()
		random_enemy = $enemy_container.get_child(rand_range(0, $enemy_container.get_child_count() - 1))
	return random_enemy

func crazy_wave():
	return
	#if $"crazy_enemies_path".get_child_count() <= max_enemies && canSpawn:
	#	var crazy_enemy =  circular_path.instance()
	#	crazy_enemy.position = Vector2(0, - 405/ 2)
	#	crazy_enemy.find_node("Enemy").connect("enemy_hit", self, "enemy_hit")
	#	$"crazy_enemies_path".add_child(crazy_enemy)
	pass

func _on_Tween_tween_all_completed(name):
	announcement_panel.visible = false
	pass

func _on_powerup_timer_timeout():
	time_passed_since_powerup = time_passed_since_powerup + powerup_timer.wait_time
	powerup_enengy.value = 100 - (time_passed_since_powerup / $Player.get_node("./Timer").wait_time) * 100
	
	if time_passed_since_powerup > 0.5:
		if powerup_clone != null && is_instance_valid(powerup_node):
			powerup_clone.queue_free()
			powerup_clone = null
	if time_passed_since_powerup > $Player.get_node("./Timer").wait_time:
		powerup_timer.stop()
	pass
	
func load_score():
	var f = File.new()
	var curr_score = 0
	
	if !f.file_exists(global.save_file_path):
		print("does not Exists")
		return 0
	f.open(global.save_file_path, File.READ)

	var curr_data = parse_json(f.get_as_text())
	if curr_data != null:
		curr_score = curr_data["score"]
	f.close()
	return curr_score
	pass

func save_score():

	global.saved_data["score"] = score
	global.current_wave = current_wave

	var curr_score = load_score()
	var f = File.new()
	f.open(global.save_file_path, File.WRITE)
	

	if score > curr_score:
		f.store_string(to_json(global.saved_data))
	f.close()
	get_tree().paused = true
	$"../game_over".visible = true
	pass

func _on_wave_timer_timeout():
	canSpawn = true
	pass
