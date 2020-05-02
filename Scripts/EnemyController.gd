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

var enemy_config = {
	1: {
		"smart": true,
		"speed": 200,
		"chaseDelay": 1.0,
		"fireDelayMin": 0.1,
		"fireDelayMax": 0.2,
		"bullet_speed": 300
	},
	2: {
		"smart": false,
		"speed": 150,
		"chaseDelay": 2.0,
		"fireDelayMin": 0.05,
		"fireDelayMax": 0.3,
		"bullet_speed": 250
	}
}

func _ready():
	set_process_input(true)
	bullet = preload("res://Nodes/Bullet.tscn")
	rng = RandomNumberGenerator.new()
	rng.randomize()
	tween = get_node("Tween")
	var which_one = 1 if rng.randf_range(0, 1) < 0.5 else 2
	enemy_selected_config = enemy_config[which_one]
	fireDelay = rand_range(enemy_selected_config["fireDelayMin"],enemy_selected_config["fireDelayMax"])
	#fireDelay = enemy_config[which_one]["fireDelayMax"]
	#fireDelay = enemy_config[which_one]["fireDelayMax"]

	speed = enemy_selected_config["speed"]
	smart = enemy_selected_config["smart"]
	play(str(which_one))
	#set_texture(load("res://Images/Players/NPC_0" + str(which_one) +  ".png"))
	bullets = []
	pass

func move_to(_pos):

	if last_chased < rand_range(0.25,enemy_selected_config["chaseDelay"]):
		return
	else:
		last_chased = 0
	if !smart:
		_pos.y = position.y

	tween.interpolate_property(self, "position", position, _pos, 0.75,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	pass

func hit():
	$explosion.visible = true
	$explosion.play("explosion")

func _process(delta):
	time_elapsed+=delta
	last_chased+=delta
	position.y = (position.y) + (speed * delta)
	if time_elapsed > fireDelay:
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
