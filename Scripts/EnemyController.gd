extends AnimatedSprite



export var fire_speed = 4
export var fireDelay = 0.2
export var canFire = true
export var speed = 100
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

signal enemy_hit(which_one)

var enemy_config = {
	1: {
		"key": 1,
		"name": "alien",
		"smart": true,
		"canShoot": true,
		"speed": 200,
		"chaseDelay": 1.0,
		"fireDelayMin": 2,
		"fireDelayMax": 2.5,
		"bullet_speed": 300,
		"health": 10,
		"chaseX": true,
		"chaseY": true
	},
	2: {
		"key": 2,
		"name": "spaceship",
		"smart": false,
		"canShoot": true,
		"speed": 150,
		"chaseDelay": 2.0,
		"fireDelayMin": 0.1,
		"fireDelayMax": 3,
		"bullet_speed": 250,
		"health": 10,
		"chaseX": true,
		"chaseY": false
	},
	3: {
		"key": 3,
		"name": "asteroid",
		"smart": false,
		"canShoot": false,
		"speed": 150,
		"chaseDelay": 2.0,
		"fireDelayMin": 0.1,
		"fireDelayMax": 3,
		"bullet_speed": 250,
		"health": 50,
		"chaseX": false,
		"chaseY": false
	}
}

func _ready():
	set_process_input(true)
	bullet = preload("res://Nodes/Bullet.tscn")
	score_lbl = $score
	rng = RandomNumberGenerator.new()
	rng.randomize()
	tween = get_node("Tween")
	enemy_selected_config = enemy_config[ randi() % enemy_config.size() + 1]
	
	fireDelay = rand_range(enemy_selected_config["fireDelayMin"],enemy_selected_config["fireDelayMax"])

	speed = enemy_selected_config["speed"]
	smart = enemy_selected_config["smart"]
	health = enemy_selected_config["health"]
	canShoot = enemy_selected_config["canShoot"]
	chaseX = enemy_selected_config["chaseX"]
	chaseY = enemy_selected_config["chaseY"]

	play(str(enemy_selected_config["key"]))
	bullets = []
	pass

func move_to(_pos):
	var canChase = chaseX == true or chaseY == true
	if last_chased < rand_range(0.25,enemy_selected_config["chaseDelay"]):
		return
	else:
		last_chased = 0
	if chaseY:
		_pos.y = position.y
	if canChase:
		tween.interpolate_property(self, "position", position, _pos, 0.75,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	pass

func hit():
	tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.25,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(score_lbl, "modulate", Color.white, Color.transparent, 0.7,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(score_lbl, "margin_top", score_lbl.margin_top, score_lbl.margin_top, score_lbl.margin_top + 100, 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	health = health - 10
	if health <= 0:
		die()
	pass

func die():
	emit_signal("enemy_hit", which_one)
	score_lbl.visible = true
	$explosion.visible = true
	$explosion_particle.visible = true
	$explosion.play("explosion")

func _process(delta):
	time_elapsed+=delta
	last_chased+=delta
	position.y = (position.y) + (speed * delta)

	if time_elapsed > fireDelay && canShoot:
		canFire = true
		fire()
		time_elapsed = 0
	pass

func fire():
	var bullet_clone = bullet.instance()

	bullet_clone.position = Vector2(self.position.x, self.position.y)
	bullet_clone.name = "enemy_bullet"
	bullet_clone.set_bullet_texture("res://Images/Enemy_Level_01_Bullet.png")
	get_parent().get_parent().add_child(bullet_clone)
	bullet_clone.fire("DOWN", enemy_selected_config["bullet_speed"])
	pass

func on_enemy_invisible():
	queue_free()

func _on_explosion_animation_finished():
	queue_free()
	pass

func on_chase_compelete(object, key):
	if key == "modulate":
		modulate = Color.white
	if canFire and key == "position":
		fire()
	pass
