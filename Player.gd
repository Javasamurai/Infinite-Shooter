extends Node2D

var speed = 3
var fire_speed = 100
var fire_delay = 1
var canMoveUp = false
var canFire
var bullet 
var isSheilded = false

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

var current_powerup
var is_pressed = false
var curr_pos = Vector2.ZERO
var last_pos = Vector2.ZERO

var global
var tween 
var is_sonic_boom
var is_powerup_live
var health_sprite

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
	$Timer.connect("timeout", self, "clear_powerup")
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
	# var acc = int(Input.get_accelerometer().x)

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
	var extra_speed
	if event is InputEventScreenDrag:
		is_pressed = true
			
		position.x = position.x + event.relative.x
		position.y = position.y + event.relative.y
	
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

func create_bullet(pos, rotate = false):
	var bullet_clone_1 = bullet.instance()
	bullet_clone_1.position = Vector2(self.position.x - (pos * 10), self.position.y)
	if rotate:
		bullet_clone_1.rotation = -20
	bullet_clone_1.name = "player_bullet_1"
	
	var bullet_clone_2 = bullet.instance()
	if rotate:
		bullet_clone_2.rotation = 20
	bullet_clone_2.position = Vector2(self.position.x + (pos * 10), self.position.y)
	bullet_clone_2.name = "player_bullet_2"

	bullet_clone_1.fire("UP", fire_speed)
	get_parent().add_child(bullet_clone_1)
	bullet_clone_2.fire("UP", fire_speed)
	get_parent().add_child(bullet_clone_2)

	pass
func fire():
	if canFire:
		canFire = false
		create_bullet(1)
		if current_powerup == "Machine gun":
			#fire_delay = 0.025
			create_bullet(2, false)
			create_bullet(3, false)

		# Firreeee!!!!
		$shot.play()
		$muzzles.visible = true
		tween.interpolate_property($muzzles, "modulate",Color.white, Color.transparent,0.075,Tween.TRANS_SINE,Tween.TRANS_LINEAR)
		tween.start()
	pass
	
func sonic_boom():
	is_sonic_boom = true
	canFire = true
	fire_delay = 0

func hit():
	emit_signal("hit")
	tween.interpolate_property($".", "modulate", Color.white,Color.transparent,0.25,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	health = health - 5

	if health <= 0 && !global.over:
		global.over = true
		time_elapsed = 0
		$Player_bg.visible = false
		$explosion.visible = true

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

func healthpotion():
	health = 100
	pass

func minify():
	tween.interpolate_property(self, "scale", Vector2.ONE,Vector2(0.25,0.25),0.25,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	pass
func clear_powerup():
	tween.interpolate_property(self, "scale", get_scale(),Vector2.ONE,0.25,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	isSheilded = false
	current_powerup = null
	modulate = Color.white

func powerup(which_one):
	$powerup.visible = true
	$powerup.play()

	is_powerup_live = true
	$Timer.start(3)

	current_powerup = which_one
	if which_one == "sonic boom":
		sonic_boom()
	elif which_one == "Minify":
		minify()
	elif which_one == "potion":
		healthpotion()
	elif which_one == "shield":
		sheild()

func sheild():
	isSheilded = true
	modulate = Color(1,1,1, 0.25)
	pass

func hit_complete(object, path):
	self.modulate = Color.white
	$muzzles.visible = false
	rotation_degrees = 0
	pass

func _on_powerup_animation_finished():
	$powerup.visible = false
	pass

func _on_swipe_area_mouse_entered():
	print("Mouse entered")
	pass
