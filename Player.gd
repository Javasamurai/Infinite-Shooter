extends Node2D

var speed = 3
var fire_speed = 300
var fire_delay = 0.25
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
var speed_damping = 0.9

signal hit
signal player_die
signal game_over

func _ready():
	global = get_node("/root/Globals")
	#var tex = load("res://Images/Players/Level_" + str(global.selected_plane) + "_Player.png")
	$Player_bg.play(str(global.selected_plane))
	tween = get_node("Tween")
	canFire = false
	is_sonic_boom = false
	bullet = preload("res://Nodes/Bullet.tscn")
	set_process_input(true)
	window_size = get_viewport_rect().size / 2
	$Timer.connect("timeout", self, "clear_powerup")
	
	print(global.selected_plane)
	if global.selected_plane == 3:
		$side_flame.visible = true
	else:
		$side_flame.visible = false
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
		#fire_delay = 0.25
		is_sonic_boom = false
	
	if health <=0 and time_elapsed > 0.5:
		emit_signal("player_die")
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
	var move_to = Vector2.ONE
	if event is InputEventScreenDrag:
		is_pressed = true
			
		#move_to.x = (position.x + event.relative.x) * 1 
		#move_to.y = (position.y + event.relative.y) * 1
		#position = move_to
		
		if event.relative.x <=0:
			tween.interpolate_property(get_node("."), "rotation_degrees", 0,-5,0.1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
			tween.start()
		else: 
			tween.interpolate_property(get_node("."), "rotation_degrees", 0,5,0.1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
			tween.start()
		translate(event.relative * speed_damping)
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
	bullet_clone_1.position = Vector2(self.position.x - (pos * 5), self.position.y)
	if rotate:
		bullet_clone_1.rotation = -20
	bullet_clone_1.name = "player_bullet_1"
	
	var bullet_clone_2 = bullet.instance()
	if rotate:
		bullet_clone_2.rotation = 20
	bullet_clone_2.position = Vector2(self.position.x + (pos * 5), self.position.y)
	bullet_clone_2.name = "player_bullet_2"
	bullet_clone_1.fire("UP", fire_speed)
	get_parent().add_child(bullet_clone_1)
	bullet_clone_2.fire("UP", fire_speed)
	get_parent().add_child(bullet_clone_2)
	pass

func fire():
	if canFire and health > 0:
		canFire = false
		create_bullet(1)
		if global.selected_plane >= 2:
			create_bullet(2, false)
			if global.selected_plane == 3:
				create_bullet(3, false)

		if current_powerup == "Machine gun":
			fire_delay = 0.001
			create_bullet(2, true)
			create_bullet(3, true)

		# Firreeee!!!!
		$shot.play()
		$Player_bg.play(str(global.selected_plane) + "_muzzle")
		$Player_bg/muzzle_timer.start()
		#$muzzles.visible = true
		
		#if global.selected_plane == 1:
		#	$muzzles1.visible = true
		#	tween.interpolate_property($muzzles1, "modulate",Color.white, Color.transparent,0.075,Tween.TRANS_SINE,Tween.TRANS_LINEAR)
		#	tween.start()
		#else:
		#tween.interpolate_property($Player_bg, "modulate",Color.white, Color.transparent,0.075,Tween.TRANS_SINE,Tween.TRANS_LINEAR)
		#tween.start()
	pass
	
func sonic_boom():
	is_sonic_boom = true
	canFire = true
	fire_delay = 0

func hit():
	tween.interpolate_property($".", "modulate", Color.white,Color.transparent,0.25,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	health = health - 20
	emit_signal("hit")

	if health <= 0 && !global.over:
		global.over = true
		emit_signal("game_over")
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
	speed_damping = 1
	pass

func clear_powerup():
	tween.interpolate_property(self, "scale", get_scale(),Vector2.ONE,0.25,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	isSheilded = false
	current_powerup = null
	modulate = Color.white
	speed_damping = 0.9
	fire_delay = 0.25

func powerup(which_one):
	$powerup.visible = true
	$powerup.play()

	is_powerup_live = true
	$Timer.start()

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
	#$muzzles.visible = false
	#$muzzles1.visible = false
	rotation_degrees = 0
	pass

func _on_powerup_animation_finished():
	$powerup.visible = false
	pass

func _on_swipe_area_mouse_entered():
	print("Mouse entered")
	pass

func _on_muzzle_timer_timeout():
	$Player_bg.play(str(global.selected_plane))
	pass


func _on_player_area_area_entered(area):
	if area.name == "enemy_area":
		hit()
	pass
