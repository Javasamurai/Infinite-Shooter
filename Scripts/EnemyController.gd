extends Sprite

export var fire_speed = 4
export var fireDelay = 2
export var canFire = true
export var speed = 100
var bullet 
var bullets
var time_elapsed = 0
var rng

var enemy_config = {
	1: {
		speed: 100,
		fireDelay: 2
	},
	2: {
		speed: 150,
		fireDelay: 1
	}
}

func _ready():
	set_process_input(true)
	bullet = preload("res://Nodes/Bullet.tscn")
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var which_one = 1 if rng.randf_range(0, 1) < 0.5 else 2
	set_texture(load("res://Images/Players/NPC_0" + str(which_one) +  ".png"))
	bullets = []
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
