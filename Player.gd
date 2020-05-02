extends Node2D

var speed = 3
var fire_speed = 100
var fire_delay = 0.25
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


var is_pressed = false
var curr_pos = Vector2.ZERO
var last_pos = Vector2.ZERO

var global
var tween 
var is_sonic_boom
signal hit

func _ready():
	global = get_node("/root/Globals")
	
	var tex = load("res://Images/Players/Level_" + str(global.selected_plane) + "_Player.png")
	$Player_bg.set_texture(tex)
	tween = get_node("Tween")
	canFire = false
	is_sonic_boom = false
	bullet = preload("res://Nodes/Bullet.tscn")
	set_process_input(true)
	window_size = get_viewport_rect().size / 2
	pass

func _process(delta):
	time_elapsed+=delta
	if time_elapsed > fire_delay && is_pressed:
		canFire = true
		fire()
		if !is_sonic_boom and !global.over:
			time_elapsed = 0
	if is_sonic_boom and time_elapsed < 3:
		fire()
	else:
		fire_delay = 0.25
		is_sonic_boom = false
	
	if health<=0 and time_elapsed > 0.5:
		get_tree().change_scene("res://Nodes/MainMenu.tscn")

	movement()

	# Gyroscope movement logic
	#var acc = int(Input.get_accelerometer().x)

	#if acc < 0:
	#	movement(DIRECTION.LEFT, acc)
	#elif int (acc) > 0:
	#	movement(DIRECTION.RIGHT, acc)

	#if canMoveUp:
	#	movement(DIRECTION.UP)
	#else:
	#	movement(DIRECTION.DOWN)
	#pass

func _input(event):
	if event is InputEventScreenDrag:
		is_pressed = true
		position.x = position.x + event.relative.x
	
	if event.is_pressed():
		is_pressed = true
	elif !(event is InputEventScreenDrag) and !(event is InputEventMouseMotion):
		is_pressed = false
	#if event is InputEventScreenTouch:
		#curr_pos = event.position - last_pos
		#if event.is_pressed():
		#	curr_pos = last_pos - event.position
		#	position = position + curr_pos
		#	print("Pressed")
		#else:
		#	last_pos = event.position
		#	print("Released")
	pass

func movement(_direction = null, _acc = null):
	var _speed = speed
	if _acc != null:
		if _acc < 0:
			_speed = speed - _acc;
		else:
			_speed = speed + _acc;
			
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene("./MainMenu.tscn")
	if Input.is_key_pressed(KEY_LEFT) || _direction == DIRECTION.LEFT:
		if self.position.x > -window_size.x:
			tween.interpolate_property(get_node("."), "rotation_degrees", 0,-5,0.1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
			tween.start()
			self.position = Vector2(self.position.x - _speed, self.position.y)
	if Input.is_key_pressed(KEY_RIGHT) || _direction == DIRECTION.RIGHT:
		if self.position.x < window_size.x:
			tween.interpolate_property(get_node("."), "rotation_degrees", 0,5,0.1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
			tween.start()
			self.position = Vector2(self.position.x + _speed, self.position.y)
	if Input.is_key_pressed(KEY_UP) || _direction == DIRECTION.UP:
		if self.position.y > -window_size.y:
			self.position = Vector2(self.position.x, self.position.y - _speed)
	if Input.is_key_pressed(KEY_DOWN) || _direction == DIRECTION.DOWN:
		if self.position.y < window_size.y + (-window_size.y * 0.2):
			self.position = Vector2(self.position.x, self.position.y + _speed)
	if Input.is_key_pressed(KEY_SPACE):
		fire()

func fire():
	if canFire:
		canFire = false
		var bullet_clone_1 = bullet.instance()
		bullet_clone_1.position = Vector2(self.position.x - 10, self.position.y)
		bullet_clone_1.name = "player_bullet"

		var bullet_clone_2 = bullet.instance()
		bullet_clone_2.position = Vector2(self.position.x + 10, self.position.y)
		bullet_clone_2.name = "player_bullet"

		# Firreeee!!!!
		$shot.play()
		bullet_clone_1.fire("UP", fire_speed)
		get_parent().add_child(bullet_clone_1)
		bullet_clone_2.fire("UP", fire_speed)
		get_parent().add_child(bullet_clone_2)
	pass
	
func sonic_boom():
	is_sonic_boom = true
	canFire = true
	fire_delay = 0

func hit():
	tween.interpolate_property($".", "modulate", Color.white,Color.transparent,0.25,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	health = health - 50
	emit_signal("hit")
	health = 10
	if health <= 0 && !global.over:
		global.over = true
		time_elapsed = 0
		$Player_bg.visible = false
		$explosion.visible = true
		#get_tree().change_scene("res://Nodes/MainMenu.tscn")
		#$explosion.connect("frame_changed", self, "explosion_changed")

func explosion_changed():
	print("Frame changed")
	pass

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

func powerup(which_one):
	$powerup.visible = true
	$powerup.play()
	if which_one == "sonic_boom":
		sonic_boom()
func hit_complete(object, key):
	get_node(".").modulate = Color.white
	rotation_degrees = 0
	pass

func _on_powerup_animation_finished():
	$powerup.visible = false
	pass


func _on_swipe_area_mouse_entered():
	print("Mouse entered")
	pass
