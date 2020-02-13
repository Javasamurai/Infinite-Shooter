extends Sprite

var speed = 1.5
var fire_speed = 3
var fire_delay = 0.5
var canMoveUp = false
var canFire
var bullet 

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
	var acc = int(Input.get_accelerometer().x)
	print(acc)
	if  acc < 0:
		movement(DIRECTION.LEFT)
	elif int (acc) > 0:
		movement(DIRECTION.RIGHT)

	#elif int (acc.y) < 0:
	#movement(DIRECTION.DOWN)
	if canMoveUp:
		movement(DIRECTION.UP)
	else:
		movement(DIRECTION.DOWN)
	#elif int (acc.y) > 0:
	pass

func movement(_direction = null):
	if Input.is_key_pressed(KEY_LEFT) || _direction == DIRECTION.LEFT:
		if self.position.x > -window_size.x:
			self.position = Vector2(self.position.x - speed, self.position.y)
			return
	if Input.is_key_pressed(KEY_RIGHT) || _direction == DIRECTION.RIGHT:
		if self.position.x < window_size.x:
			self.position = Vector2(self.position.x + speed, self.position.y)
			return
	if Input.is_key_pressed(KEY_UP) || _direction == DIRECTION.UP:
		if self.position.y > -window_size.y:
			self.position = Vector2(self.position.x, self.position.y - speed)
			return
	if Input.is_key_pressed(KEY_DOWN) || _direction == DIRECTION.DOWN:
		if self.position.y < window_size.y + (-window_size.y * 0.2):
			self.position = Vector2(self.position.x, self.position.y + speed)
			return
	if Input.is_key_pressed(KEY_SPACE):
		fire()

func fire():
	if canFire:
		canFire = false
		var bullet_clone = bullet.instance()
		bullet_clone.position = Vector2(self.position.x, self.position.y)
		bullet_clone.name = "player_bullet"
		# Firreeee!!!!
		$shot.play()
		bullet_clone.fire("UP", fire_speed)
		get_parent().add_child(bullet_clone)
	pass

func _on_Touchables_input_event(viewport, event, shape_idx):
	#print(event)
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if !event.pressed:
			canMoveUp = false
			movement(DIRECTION.DOWN)
		if shape_idx == 0 && event.pressed:
			canMoveUp = true
		elif shape_idx == 1:
			fire()
	pass
