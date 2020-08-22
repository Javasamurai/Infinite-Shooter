extends Path2D

var fired = false
var fire_speed  = 10


func _ready():
	set_process(true)
	pass

func _process(delta):
	if fired:
		if $PathFollow2D.offset <= 215:
			$PathFollow2D.offset = $PathFollow2D.offset + (fire_speed / 3) * delta
		else:
			queue_free()
	pass
	
func fire(direction, _fire_speed):
	fired = true
	fire_speed = _fire_speed
	pass
