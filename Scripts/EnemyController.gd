extends Sprite

export var fire_speed = 3
export var fireDelay = 1
export var canFire = true
var bullet 
var bullets
var time_elapsed = 0

func _ready():
	set_process_input(true)
	bullet = preload("res://Bullet.tscn")
	bullets = []
	pass

func _process(delta):
	time_elapsed+=delta
	if time_elapsed > fireDelay:
		canFire = true
		fire()
		time_elapsed = 0
	pass

func fire():
	var bullet_clone = bullet.instance()
	bullet_clone.position = Vector2(self.position.x, self.position.y)
	bullet_clone.name = "enemy_bullet"
	get_parent().add_child(bullet_clone)
	bullet_clone.fire("DOWN", fire_speed)
	pass