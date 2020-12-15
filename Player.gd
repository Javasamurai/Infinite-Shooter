extends Node2D

var speed = 3
var fire_speed = 600
var fire_delay = 0.15
var canMoveUp = false
var canFire
var bullet 
var curvy_bullet
var isSheilded = false

var time_elapsed = 0
var health = 300
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


var drone_object
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
signal left
signal right

func _ready():
	global = get_node("/root/Globals")
	global.over = false 
	#var tex = load("res://Images/Players/Level_" + str(global.selected_plane) + "_Player.png")
	drone_object = preload("res://Nodes/drone.tscn")
	$Player_bg.play(str(global.selected_plane))
	tween = get_node("Tween")
	#$drone_left.positioning = "left"
	$drone_right.positioning = "right"
	
	if get_tree().get_current_scene().get_name() != "MainMenu":
		tween.interpolate_property(self, "position", Vector2(0,250),Vector2(0, 150),1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
		tween.start()

	canFire = false
	is_sonic_boom = false
	
	bullet = preload("res://Nodes/Bullet.tscn")
	curvy_bullet = preload("res://Nodes/CurvyBullet.tscn")

	clear_powerup()
	
	set_process_input(true)
	window_size = get_viewport_rect().size / 2
	$Timer.connect("timeout", self, "clear_powerup")
	
	if global.selected_plane == 3:
		$side_flame.visible = true
	else:
		$side_flame.visible = false
	pass

func canFire():
	return canFire && get_tree().get_current_scene().get_name() != "MainMenu"

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

func _input(event):
	var extra_speed
	var move_to = Vector2.ONE
	if event is InputEventScreenDrag:
		is_pressed = true

		#move_to.x = (position.x + event.relative.x) * 1 
		#move_to.y = (position.y + event.relative.y) * 1
		#position = move_to
		if event.relative.x != 0:
			if event.relative.x < 0:
				tween.interpolate_property(get_node("."), "rotation_degrees", 0,-5,0.1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
				tween.start()
			else:
				tween.interpolate_property(get_node("."), "rotation_degrees", 0,5,0.1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
				tween.start()
			translate(event.relative * speed_damping)
	#if event.is_pressed():
	#	is_pressed = true
	elif !(event is InputEventScreenDrag) and !(event is InputEventMouseMotion):
		is_pressed = false
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
	if Input.is_key_pressed(KEY_SPACE):
		is_pressed = true

	if Input.is_key_pressed(KEY_LEFT) || _direction == DIRECTION.LEFT:
		if self.position.x > -window_size.x:
			emit_signal("left")
			tween.interpolate_property(get_node("."), "rotation_degrees", 0,-5,0.1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
			tween.start()
			self.position = Vector2(self.position.x - _speed, self.position.y)
	if Input.is_key_pressed(KEY_RIGHT) || _direction == DIRECTION.RIGHT:
		if self.position.x < window_size.x:
			emit_signal("right")
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

func spawnDrone():
	var drone1 = drone_object.instance()
	var drone2 = drone_object.instance()

	drone1.name = "drone1"
	drone1.positioning = "left"
	drone2.name = "drone2"
	drone1.positioning = "right"
	
	drone1.position = Vector2.ZERO
	drone2.position = Vector2.ZERO
	$drone1_parent.add_child(drone1)
	$drone2_parent.add_child(drone2)	
	pass

func drone(target1, target2):
	var first_drone_child = $drone1_parent.get_child_count()
	var second_drone_child = $drone2_parent.get_child_count()
	if first_drone_child == 0 && second_drone_child == 0:
		spawnDrone()

	var drone1 = $drone1_parent/drone1
	var drone2 = $drone2_parent/drone2

	if drone1 != null && drone2 != null:
		drone1.activate(target1)
		drone2.activate(target2)
	pass

func create_bullet(pos, rotate = false, missile = false, laser = false):
	var bullet_clone_1
	var bullet_clone_2
	
	if missile:
		bullet_clone_1 = curvy_bullet.instance()
		bullet_clone_2 = curvy_bullet.instance()
		bullet_clone_1.set_bullet_texture("res://Images/Bullet_purple.png")
		bullet_clone_2.set_bullet_texture("res://Images/Bullet_purple.png")

		bullet_clone_2.scale.x = -1
	else:
		bullet_clone_1 = bullet.instance()
		bullet_clone_2 = bullet.instance()

	if laser:
		$player_bullet_laser.visible = true

	bullet_clone_1.name = "player_bullet_1"
	bullet_clone_2.name = "player_bullet_2"

	var extra_space = 0
	#if pos <= 3:
	#	yield (get_tree().create_timer((pos - 3) / 4), "timeout")
	if pos >= 2:
		extra_space = pos
	bullet_clone_1.position = Vector2(self.position.x - (pos * 5), self.position.y + extra_space)
	if rotate:
		bullet_clone_1.rotation = -10

	if rotate:
		bullet_clone_2.rotation = 10
	bullet_clone_2.position = Vector2(self.position.x + (pos * 5), self.position.y + extra_space)
	bullet_clone_1.fire("UP", fire_speed)
	get_parent().add_child(bullet_clone_1)
	bullet_clone_2.fire("UP", fire_speed)
	get_parent().add_child(bullet_clone_2)
	pass

func fire():
	if canFire() and health > 0:
		canFire = false
		if current_powerup == "missile":
			create_bullet(1, false, true)
		elif current_powerup == "laser":
			create_bullet(1, false, false, true)
		create_bullet(1)
		if global.selected_plane >= 2:
			create_bullet(2, true)
			if global.selected_plane == 3:
				create_bullet(3, true)

		#current_powerup = ""
		if current_powerup == "Machine gun":
			fire_delay = 0.01
			create_bullet(2, true)
			create_bullet(3, true)

		# Firreeee!!!!
		if global.saved_data["music"]:
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
	if isSheilded:
		return
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

func _on_Accelerate(_viewport, event, shape_idx):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if !event.pressed:
			canMoveUp = false
			movement(DIRECTION.DOWN)
		elif shape_idx == 0:
			canMoveUp = true
	pass

func healthpotion():
	health = 300
	pass

func minify():
	tween.interpolate_property(self, "scale", Vector2.ONE,Vector2(0.25,0.25),0.25,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	speed_damping = 1.2
	pass

func clear_powerup():
	time_elapsed = 0
	$shield.visible = false
	$player_bullet_laser.visible = false

	tween.interpolate_property(self, "scale", get_scale(),Vector2.ONE,0.25,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	isSheilded = false
	current_powerup = null
	modulate = Color.white
	speed_damping = 0.9
	fire_delay = 0.15
	is_sonic_boom = false
	is_pressed = false
	canFire = false


func powerup(which_one):
	$powerup.visible = true
	$powerup.play()

	is_powerup_live = true
	$Timer.start()

	current_powerup = which_one
	if which_one == "sonic boom":
		sonic_boom()
	elif which_one == "minify":
		minify()
	elif which_one == "potion":
		healthpotion()
	elif which_one == "shield":
		sheild()

func sheild():
	$shield.visible = true
	isSheilded = true
	#modulate = Color(1,1,1, 0.25)
	pass

func hit_complete(_object, _path):
	self.modulate = Color.white
	#$muzzles.visible = false
	#$muzzles1.visible = false
	
	if rotation_degrees !=0:
		tween.interpolate_property(get_node("."), "rotation_degrees", rotation_degrees,0,0.075,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
		tween.start()
	pass

func _on_powerup_animation_finished():
	$powerup.visible = false
	pass

func _on_muzzle_timer_timeout():
	$Player_bg.play(str(global.selected_plane))
	pass


func _on_player_area_area_entered(area):
	var _node_name = self.name
	var area_name = area.get_node("..").name
	var isPlayer_bullet = area_name.find("player_bullet") != -1
	var isEnemy_bullet = area_name.find("enemy_bullet") != -1
	var hitPlayer_body = (_node_name.find("Player") != -1)
	var hitEnemy_body = (_node_name.find("Enemy") != -1)
	
	if isEnemy_bullet && hitPlayer_body:
		hit()
		area.get_node("../").queue_free()

	if area.name == "enemy_area":
		hit()
	pass
