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
	bullet = preload("res://Nodes/Bullet.tscn")
	set_process_input(true)
	window_size = get_viewport_rect().size / 2
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	pass

#func _input(event):
#	if event.
#	pass

func _process(delta):
	time_elapsed+=delta
	if time_elapsed > fire_delay:
		canFire = true
		time_elapsed = 0
	movement()
	var acc = int(Input.get_accelerometer().x)
	if  acc < 0:
		movement(DIRECTION.LEFT)
	elif int (acc) > 0:
		movement(DIRECTION.RIGHT)

	if canMoveUp:
		movement(DIRECTION.UP)
	else:
		movement(DIRECTION.DOWN)
	pass

func movement(_direction = null):
	if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().change_scene("./MainMenu.tscn")
	if Input.is_key_pressed(KEY_LEFT) || _direction == DIRECTION.LEFT:
		if self.position.x > -window_size.x:
			self.position = Vector2(self.position.x - speed, self.position.y)
	if Input.is_key_pressed(KEY_RIGHT) || _direction == DIRECTION.RIGHT:
		if self.position.x < window_size.x:
			self.position = Vector2(self.position.x + speed, self.position.y)
	if Input.is_key_pressed(KEY_UP) || _direction == DIRECTION.UP:
		if self.position.y > -window_size.y:
			self.position = Vector2(self.position.x, self.position.y - speed)
	if Input.is_key_pressed(KEY_DOWN) || _direction == DIRECTION.DOWN:
		if self.position.y < window_size.y + (-window_size.y * 0.2):
			self.position = Vector2(self.position.x, self.position.y + speed)
	if Input.is_key_pressed(KEY_SPACE):
		fire()

func fire():
	if canFire:
		canFire = false
		var bullet_clone = bullet.instance()
		bullet_clone.position = Vector2(self.position.x, self.position.y)
		bullet_clone.name = "player_bullet"
		# Firreeee!!!!
		# $shot.play()
		bullet_clone.fire("UP", fire_speed)
		get_parent().add_child(bullet_clone)
	pass

func _on_Fire(viewport, event, shape_idx):
	fire()

func _on_Accelerate(viewport, event, shape_idx):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if !event.pressed:
			canMoveUp = false
			movement(DIRECTION.DOWN)
		elif shape_idx == 0:
			canMoveUp = true
	pass
