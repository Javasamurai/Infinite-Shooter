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

var enemy_config = {
	1: {
		"smart": true,
		"speed": 200,
		"fireDelay": 0.2
	},
	2: {
		"smart": false,
		"speed": 150,
		"fireDelay": 0.25
	}
}

func _ready():
	set_process_input(true)
	bullet = preload("res://Nodes/Bullet.tscn")
	rng = RandomNumberGenerator.new()
	rng.randomize()
	tween = get_node("Tween")
	
	
	var which_one = 1 if rng.randf_range(0, 1) < 0.5 else 2
	
	fireDelay = enemy_config[which_one]["fireDelay"]
	speed = enemy_config[which_one]["speed"]
	smart = enemy_config[which_one]["smart"]
	play(str(which_one))
	#set_texture(load("res://Images/Players/NPC_0" + str(which_one) +  ".png"))
	bullets = []
	pass

func move_to(_pos):
	tween.interpolate_property(self, "position", position, _pos, 0.75,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	pass

func hit():
	queue_free()

func _process(delta):
	time_elapsed+=delta
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
	bullet_clone.fire("DOWN", fire_speed)
	pass

func on_enemy_invisible():
	queue_free()
