extends Sprite

var speed = 3
var fire_speed = 3
var fire_delay = 0.5
var canMoveUp = false
var canFire
var bullet 

var time_elapsed = 0
var health = 100
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

var global
var tween 
signal hit

func _ready():
	global = get_node("/root/Globals")
	var tex = load("res://Images/Players/Level_" + str(global.selected_plane) + "_Player.png")
	set_texture(tex)
	tween = get_node("Tween")
	canFire = false
	bullet = preload("res://Nodes/Bullet.tscn")
	set_process_input(true)
	window_size = get_viewport_rect().size / 2
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
		$shot.play()
		bullet_clone.fire("UP", fire_speed)
		get_parent().add_child(bullet_clone)
	pass

func hit():
	tween.interpolate_property($".", "modulate", Color.white,Color.transparent,0.25,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	health = health - 20
	emit_signal("hit")
	if health <= 0:
		global.over = true
		get_tree().change_scene("res://Nodes/MainMenu.tscn")
		print("You are doomed: Game over")

func _on_Fire(viewport, _event, _shape_idx):
	fire()

func _on_Accelerate(_viewport, event, shape_idx):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if !event.pressed:
			canMoveUp = false
			movement(DIRECTION.DOWN)
		elif shape_idx == 0:
			canMoveUp = true
	pass

func hit_complete(object, key):
	get_node(".").modulate = Color.white
	#tween.interpolate_property(get_node("."), "modulate", Color.transparent,Color.white,0.1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	#tween.start()
	pass
