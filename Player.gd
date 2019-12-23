extends Sprite

var speed = 5
var fire_speed = 3
var fire_delay = 0.5
var canFire
var bullet 
var bullets
var time_elapsed = 0

func _ready():
	canFire = false
	bullet = preload("res://Bullet.tscn")
	set_process_input(true)
	bullets = []
	pass

func _process(delta):
	time_elapsed+=delta
	print(time_elapsed)
	if time_elapsed > fire_delay:
		canFire = true
		time_elapsed = 0
	if Input.is_key_pressed(KEY_LEFT):
		self.position = Vector2(self.position.x - speed, self.position.y)
	elif Input.is_key_pressed(KEY_RIGHT):
		self.position = Vector2(self.position.x + speed, self.position.y)		
	elif Input.is_key_pressed(KEY_UP):
		self.position = Vector2(self.position.x, self.position.y - speed)		
	elif Input.is_key_pressed(KEY_DOWN):
		self.position = Vector2(self.position.x, self.position.y + speed)		
	elif Input.is_key_pressed(KEY_SPACE):
		fire()
	
	if bullets.size() > 0:
		for single_bullet in bullets:
			single_bullet.position = Vector2(single_bullet.position.x, single_bullet.position.y - fire_speed)
		pass
	pass

func fire():
	if canFire:
		canFire = false
		var bullet_clone = bullet.instance()
		bullet_clone.position = Vector2(self.position.x, self.position.y)
		# Firreeee!!!!
		get_parent().add_child(bullet_clone)
		bullets.insert(bullets.size(), bullet_clone)
	pass
