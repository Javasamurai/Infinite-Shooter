extends Camera2D

var player
var enemy
var powerup_node
var powerup_container
var powerup_clone
var enemy_list = []
var max_enemies = 5
var time_elapsed = 0
var powerup_spawn_delay = 7
var isPowerSpawned = false
var canSpawn = true
var spawnDelay = 1
var last_spawned_time
var screenBounds = Vector2.ZERO
var last_position = Vector2.ZERO
var temp_position = Vector2.ZERO
export(NodePath) var health_label

#Screen Shake

export var decay_rate = 0.4
export var max_yaw = 0.05
export var max_pitch = 0.05
export var max_roll = 0.1
export var max_offset = 0.2

var _start_position
var _start_rotation
var _trauma



signal hit

func _ready():
	set_process(true)
	screenBounds = get_viewport_rect().size
	enemy_list = []
	last_spawned_time = 0
	enemy = preload("res://Nodes/Enemy.tscn")
	player = preload("res://Nodes/Player.tscn")
	powerup_node = preload("res://Nodes/powerup.tscn")
	$Player.connect("hit",self, "on_player_hit")
	powerup_container = $powerup_container
	_start_position = position
	_start_rotation = rotation
	_trauma = 0.0
	add_trauma(0.7)
	
func _process(delta):
	time_elapsed+=delta
	last_spawned_time+= delta

	if _trauma > 0:
		_decay_trauma(delta)
		_apply_shake()
	if time_elapsed > 0.25:
		for i in range($enemy_container.get_child_count()):
			var enemy = $enemy_container.get_child(i)

			if enemy.smart:
				enemy.move_to($Player.position)
			
	if last_spawned_time > spawnDelay:
		last_spawned_time = 0
		canSpawn = true
		spawnEnemies()

	if (int(time_elapsed) % powerup_spawn_delay) == 0 and powerup_container.get_child_count() == 0 and time_elapsed > 0:
		isPowerSpawned = true
		spawnPowerup()
	pass

func _input(event):
	if event is InputEventScreenDrag:
		return
		temp_position = event.get("position")
		if $Player != null:
			if temp_position.x > last_position.x:
				$Player.movement($Player.DIRECTION.RIGHT)
			elif temp_position.x < last_position.x:
				$Player.movement($Player.DIRECTION.LEFT)
			elif temp_position.y < last_position.y:
				$Player.movement($Player.DIRECTION.UP)
			elif temp_position.y > last_position.y:
				$Player.movement($Player.DIRECTION.DOWN)
			last_position = temp_position
	pass

func on_player_hit():
	get_node(health_label).set_text(str($Player.health))
	add_trauma(0.2)
	pass
	
func spawnPowerup():
	isPowerSpawned = true
	powerup_clone = powerup_node.instance()
	var collision_area = powerup_clone.find_node("powerup_area")
	collision_area.connect("area_entered", self ,"_on_powerup_got")

	powerup_clone.position = Vector2(rand_range(-screenBounds.x / 2, screenBounds.x / 2), -(screenBounds.y / 2))
	powerup_container.add_child(powerup_clone)
	pass

func _on_powerup_got(areas):
	if areas.name == "bullet_area":
		$powerup.play()
		powerup_clone.queue_free()
		$Player.powerup("sonic_boom")

func spawnEnemies():
	# check current enemies
	var enemy_counter = 0

	if $enemy_container.get_child_count() <= max_enemies && canSpawn:
		enemy_counter = enemy_counter + 1
		var enemy_clone = enemy.instance()
		var texture = enemy_clone.get_sprite_frames().get_frame("1", 0)

		enemy_clone.position = Vector2(rand_range(-screenBounds.x / 2 + texture.get_size().x / 2, screenBounds.x / 2- texture.get_size().x / 2), -(screenBounds.y / 2) + texture.get_size().y)
		$enemy_container.add_child(enemy_clone)

		if enemy_clone.smart:
			enemy_clone.move_to($Player.position)
	pass


func _on_speed_changed():
	pass

func add_trauma(amount):
	_trauma = min(_trauma + amount, 1)


func _decay_trauma(delta):
	var change = decay_rate * delta
	_trauma = max(_trauma - change, 0)

func _apply_shake():
	var shake = _trauma * _trauma
	var yaw = max_yaw * shake * _get_neg_or_pos_scalar()
	var pitch = max_pitch * shake * _get_neg_or_pos_scalar()
	var roll = max_roll * shake * _get_neg_or_pos_scalar()
	var o_x = max_offset * shake * _get_neg_or_pos_scalar()
	var o_y = max_offset * shake * _get_neg_or_pos_scalar()
	var o_z = max_offset * shake * _get_neg_or_pos_scalar()
	translate(_start_position + Vector2(o_x, o_y))
	#transform = _start_position + Vector3(o_x, o_y, o_z)
	#rotation = _start_rotation + Vector3(pitch, yaw, roll)

func _get_neg_or_pos_scalar():
		return rand_range(-1.0, 1.0)
