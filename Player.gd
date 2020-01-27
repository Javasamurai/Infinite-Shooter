extends Sprite

var speed = 1
var fire_speed = 3
var fire_delay = 0.5
var canFire
var bullet 
var bullets
var time_elapsed = 0
var window_size = {
	"x": 0,
	"y": 0
	}
enum DIRECTION {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

func _ready():
	canFire = false
	bullet = preload("res://Bullet.tscn")
	set_process_input(true)
	window_size = get_viewport_rect().size / 2
	pass

func _process(delta):
	time_elapsed+=delta
	if time_elapsed > fire_delay:
		canFire = true
		time_elapsed = 0
	movement()
	pass

func movement(_direction = null):
	if Input.is_key_pressed(KEY_LEFT) || _direction == DIRECTION.LEFT:
		$player_audio.play()
		if self.position.x > -window_size.x:
			self.position = Vector2(self.position.x - speed, self.position.y)
	elif Input.is_key_pressed(KEY_RIGHT) || _direction == DIRECTION.RIGHT:
		$player_audio.play()
		if self.position.x < window_size.x:
			self.position = Vector2(self.position.x + speed, self.position.y)		
	elif Input.is_key_pressed(KEY_UP) || _direction == DIRECTION.UP:
		$player_audio.play()
		if self.position.y > -window_size.y:
			self.position = Vector2(self.position.x, self.position.y - speed)		
	elif Input.is_key_pressed(KEY_DOWN) || _direction == DIRECTION.DOWN:
		$player_audio.play()
		if self.position.y < window_size.y:
			self.position = Vector2(self.position.x, self.position.y + speed)		
	elif Input.is_key_pressed(KEY_SPACE):
		fire()

func fire():
	if canFire:
		$shot.play()
		canFire = false
		var bullet_clone = bullet.instance()
		bullet_clone.position = Vector2(self.position.x, self.position.y)
		bullet_clone.name = "player_bullet"
		# Firreeee!!!!
		bullet_clone.fire("UP", fire_speed)
		get_parent().add_child(bullet_clone)
	pass
