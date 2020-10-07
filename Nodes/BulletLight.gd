extends Sprite


var is_firing = false
var fire_speed = 20
var a = 0
func _ready():
	pass

func fire(_direction, _fire_speed):
	is_firing = true
	fire_speed = _fire_speed
	pass

func _process(delta):
	if is_firing:
		a += 25 * delta 
		position = Vector2(position.x + sin(a) * 20, position.y + cos(a) * 20)

	pass
