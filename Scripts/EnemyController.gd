extends AnimatedSprite



export var fire_speed = 4
export var fireDelay = 0.2
export var canFire = true
export var speed = 100
export var autoStart = false
export var presetEnemy = 0

var bullet
var bullets
var time_elapsed = 0
var rng
var smart = false
var tween
var enemy_selected_config
var last_chased = 0
var which_one
var score_lbl
var health = 10
var canShoot = true
var chaseX = true
var chaseY = true
var key = 1
var bullet_type = "normal"
var canRotate = false
var path_node = null
var current_wave = 1
#var selected_color
var is_active = false
signal enemy_hit(which_one)
var coin_node

var enemy_config = {
	1: {
		"key": 1,
		"name": "spaceship",
		"bullet_type": "normal",
		"canRotate": false,
		"smart": false,
		"canShoot": true,
		"speed": 75,
		"chaseDelay": 2.0,
		"fireDelayMin": 2.4,
		"fireDelayMax": 2.5,
		"bullet_speed": 300,
		"health": 20,
		"chaseX": false,
		"chaseY": false
	},
	2: {
		"key": 2,
		"name": "small_plane",
		"bullet_type": "normal",
		"canRotate": false,
		"smart": false,
		"canShoot": false,
		"speed": 75,
		"chaseDelay": 2.0,
		"fireDelayMin": 2,
		"fireDelayMax": 3,
		"bullet_speed": 75,
		"health": 50,
		"chaseX": false,
		"chaseY": false
	},
	3: {
		"key": 3,
		"name": "asteroid",
		"bullet_type": "normal",
		"canRotate": true,
		"smart": false,
		"canShoot": false,
		"speed": 50,
		"chaseDelay": 2.0,
		"fireDelayMin": 2,
		"fireDelayMax": 3,
		"bullet_speed": 250,
		"health": 50,
		"chaseX": false,
		"chaseY": false
	},
	4: {
		"key": 4,
		"name": "asteroid",
		"bullet_type": "normal",
		"canRotate": true,
		"smart": false,
		"canShoot": false,
		"speed": 70,
		"chaseDelay": 2.0,
		"fireDelayMin": 0.1,
		"fireDelayMax": 3,
		"bullet_speed": 300,
		"health": 50,
		"chaseX": false,
		"chaseY": false
	},
	5: {
		"key": 5,
		"name": "asteroid",
		"bullet_type": "normal",
		"canRotate": false,
		"smart": false,
		"canShoot": false,
		"speed": 30,
		"chaseDelay": 2.0,
		"fireDelayMin": 0.1,
		"fireDelayMax": 3,
		"bullet_speed": 150,
		"health": 50,
		"chaseX": false,
		"chaseY": false
	},
	6: {
		"key": 6,
		"name": "alien",
		"bullet_type": "normal",
		"canRotate": false,
		"smart": false,
		"canShoot": true,
		"speed": 40,
		"chaseDelay": 2.0,
		"fireDelayMin": 2,
		"fireDelayMax": 2,
		"bullet_speed": 200,
		"health": 80,
		"chaseX": true,
		"chaseY": false
	},
	7: {
		"key": 7,
		"name": "big_plane",
		"bullet_type": "sided",
		"canRotate": true,
		"smart": true,
		"canShoot": true,
		"speed": 30,
		"chaseDelay": 2.0,
		"fireDelayMin": 2.5,
		"fireDelayMax": 2.7,
		"bullet_speed": 250,
		"health": 80,
		"chaseX": true,
		"chaseY": true
	},
	8: {
		"key": 8,
		"name": "plane",
		"bullet_type": "spiral",
		"canRotate": false,
		"smart": false,
		"canShoot": true,
		"speed": 20,
		"chaseDelay": 2.0,
		"fireDelayMin": 2,
		"fireDelayMax": 2,
		"bullet_speed": 250,
		"health": 50,
		"chaseX": false,
		"chaseY": false
	},
	9: {
		"key": 9,
		"name": "big_ufo",
		"bullet_type": "spiral",
		"canRotate": false,
		"smart": true,
		"canShoot": true,
		"speed": 0,
		"chaseDelay": 0.26,
		"fireDelayMin": 2,
		"fireDelayMax": 2,
		"bullet_speed": 300,
		"health": 300,
		"chaseX": true,
		"chaseY": false
	},
	10: {
		"key": 10,
		"name": "new_enemy_1",
		"bullet_type": "sided",
		"canRotate": false,
		"smart": true,
		"canShoot": true,
		"speed": 15,
		"chaseDelay": 2.0,
		"fireDelayMin": 2,
		"fireDelayMax": 2,
		"bullet_speed": 250,
		"health": 250,
		"chaseX": true,
		"chaseY": false
	},
	11: {
		"key": 11,
		"name": "new_enemy_2",
		"bullet_type": "sided",
		"canRotate": false,
		"smart": true,
		"canShoot": true,
		"speed": 5,
		"chaseDelay": 2.0,
		"fireDelayMin": 2,
		"fireDelayMax": 2,
		"bullet_speed": 250,
		"health": 500,
		"chaseX": false,
		"chaseY": false
	},
	12: {
		"key": 12,
		"name": "new_enemy_3",
		"bullet_type": "sided",
		"canRotate": false,
		"smart": true,
		"canShoot": true,
		"speed": 5,
		"chaseDelay": 2.0,
		"fireDelayMin": 2,
		"fireDelayMax": 2,
		"bullet_speed": 250,
		"health": 750,
		"chaseX": false,
		"chaseY": false
	}
}

var alien_colors = [Color.white, Color.aqua, Color.black, Color.blue, Color.yellow]
var dead = false
var global

func _ready():
	randomize()
	set_process_input(true)
	global = get_node("/root/Globals")
	bullet = preload("res://Nodes/Bullet.tscn")
	coin_node = preload("res://coin.tscn")
	path_node = find_node("path")

	score_lbl = $score
	rng = RandomNumberGenerator.new()
	rng.randomize()
	tween = get_node("Tween")
	var rect_shape = RectangleShape2D.new()
	var _size = frames.get_frame(str(presetEnemy), 0).get_size()
	
	rect_shape.extents = Vector2(_size.x, _size.y)
	$enemy_area/CollisionShape2D.shape = rect_shape

	if autoStart:
		generate_enemy(999)
	# randomly change alien color
	# if key == 2:
	#	modulate = alien_colors[randi() % alien_colors.size()]
	# pass

func generate_enemy(max_enemies = enemy_config.size()):
	is_active = true
	current_wave = max_enemies
	if autoStart:
		enemy_selected_config = enemy_config[presetEnemy]
	else:
		enemy_selected_config = enemy_config[ randi() % max_enemies + 1]
	fireDelay = rand_range(enemy_selected_config["fireDelayMin"],enemy_selected_config["fireDelayMax"])

	speed = enemy_selected_config["speed"]
	smart = enemy_selected_config["smart"]
	health = enemy_selected_config["health"]
	canShoot = enemy_selected_config["canShoot"]
	chaseX = enemy_selected_config["chaseX"]
	chaseY = enemy_selected_config["chaseY"]
	key = enemy_selected_config["key"]
	canRotate = enemy_selected_config["canRotate"]
	bullet_type = enemy_selected_config["bullet_type"]

	play(str(key))
	bullets = []
	pass

func move_to(_pos):
	var canChase = (chaseX == true or chaseY == true) && current_wave > 3
	
	if last_chased < rand_range(0.25,enemy_selected_config["chaseDelay"]):
		return
	else:
		last_chased = 0
	if chaseY:
		_pos.y = global_position.y
	
	if canChase:
		tween.interpolate_property(self, "global_position", global_position, _pos, 3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	pass

func hit(full = false):
	tween.interpolate_property(self, "modulate", Color.white, Color(0,0,0,0.5), 0.25,Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "position", position, Vector2(position.x, position.y - 6), 0.1,Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$AnimationPlayer.play("hit")
	score_lbl.visible = true
	
	health = health - 10

	tween.interpolate_property(score_lbl, "modulate", Color.white, Color.transparent, 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(score_lbl, "margin_top", score_lbl.margin_top, score_lbl.margin_top, score_lbl.margin_top + 200, 0.75,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	if full:
		health = -1000

	if health <= 0 && !dead:
		dead = true
		if global.saved_data["music"]:
			$death_sfx.play()
		die()
	else:
		if global.saved_data["music"]:
			$hit_sfx.play()

	if key == 1 or key == 2:
		$Timer.wait_time = 0.15
		$Timer.start()
		play("hit_"+ str(key))
	pass

func reset_anim():
	play(str(key))
	pass

func die():
	emit_signal("enemy_hit", key)
	score_lbl.visible = true
	$explosion.visible = true
	$explosion_particle.visible = true
	$death_timer.start()
	
	var coin_clone = coin_node.instance()
	coin_clone.position = self.global_position
	coin_clone.move = true
	
	get_node("../..").add_child(coin_clone)
	if global.saved_data["music"]:
		$explosion.play("explosion")

func _process(delta):
	if !is_active:
		return
	time_elapsed+=delta
	last_chased+=delta
	position.y = (position.y) + (speed * delta)
	if path_node != null:
		path_node.off
	if canRotate:
		rotation = rotation + (5 * delta)
	if time_elapsed > fireDelay && canShoot:
		canFire = true
		if bullet_type == "spiral":
			fire_spiral()
		elif bullet_type == "sided":
			fire_side()
		else:
			fire()
		time_elapsed = 0

	if position.y > 1500:
		on_enemy_invisible()
	pass
	
func fire_side():
	create_bullet("LEFT")
	create_bullet("UP")
	create_bullet("RIGHT")
	create_bullet("DOWN")
	pass

func fire_spiral():
	create_bullet("LEFT")
	create_bullet("UP")
	create_bullet("RIGHT")
	create_bullet("DOWN")
	
	create_bullet("TOP_RIGHT")
	create_bullet("TOP_LEFT")
	create_bullet("BOTT_LEFT")
	create_bullet("BOTT_RIGHT")
	pass

func fire_random():
	create_bullet("RANDOM")

func create_bullet(direction):
	var bullet_clone = bullet.instance()

	if enemy_selected_config == null:
		return

	bullet_clone.position = global_position
	bullet_clone.name = "enemy_bullet"
	
	if key > 3:
		bullet_clone.set_bullet_texture("res://Images/Enemy_Bullet_01.png")
	else:
		bullet_clone.set_bullet_texture("res://Images/Enemy_Bullet_01.png")

	get_parent().get_parent().add_child(bullet_clone)
	bullet_clone.fire(direction, enemy_selected_config["bullet_speed"])
	pass

func fire():
	create_bullet("DOWN")
	pass

func on_enemy_invisible():
	queue_free()
	#$"..".checkWave()
	pass

func _on_explosion_animation_finished():
	queue_free()
	pass

func on_chase_compelete(_object, _key):
	if _key == ":modulate":
		self.modulate = Color.white
	if canFire && _key == ":position" && canShoot && (chaseX || chaseY):
		fire()
	pass


func _on_enemy_area_area_entered(area):
	var _node_name = self.name
	var area_name = area.get_node("..").name

	var isPlayer_bullet = area_name.find("player_bullet") != -1
	var isEnemy_bullet = area_name.find("enemy_bullet") != -1
	var hitPlayer_body = (_node_name.find("player_area") != -1)
	var hitEnemy_body = (_node_name.find("Enemy") != -1)
	
	if isPlayer_bullet && hitEnemy_body:
		hit()
		if area_name.find("laser") == -1:
			area.get_node("../").queue_free()
	pass
