extends Sprite


var is_firing = false
var fire_speed = 10
var DIRECTION = "DOWN"

var a = 0
var angle = 0
var radius = 0
func _ready():
	pass

func fire(_direction, _fire_speed, _angle):
	is_firing = true
	fire_speed = _fire_speed
	angle = _angle
	DIRECTION = _direction

	var t = Timer.new()
	t.set_one_shot(true)
	t.set_wait_time(5)
	t.start()
	t.connect("timeout", self, "selfDestruct")

	pass

func _process(delta):
	if is_firing:
		##########
		## FOR SPIRAL FIRING ##
		##########
		a = angle
		#a += 10 * delta
		#a += 2 * delta
		
		radius = radius + delta * fire_speed

		position = Vector2( position.x + sin(a) * radius * delta, position.y + cos(a) * radius * delta)
		
		##########
		## FOR RANDOM FIRING ##
		##########
		#var moveX = randf() < 0.5
		#var moveY = randf() < 0.5
		
		#position = Vector2(position.x + 1 * delta * fire_speed if moveX  else position.x - 1  * delta * fire_speed, position.y + 1 * delta * fire_speed if moveY else position.y - 1  * delta * fire_speed)
		
		##########
		## FOR FLOWER FIRING ##
		##########
		#a += 10 * delta
		#a += 2 * delta
		#radius = radius + delta * fire_speed
		#position = Vector2( position.x + sin(a) * radius * delta, position.y + cos(a) * radius * delta)
	pass
	
func selfDestruct():
	queue_free()
	pass
