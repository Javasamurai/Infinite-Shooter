extends Node2D


var isFiring = false
var _direction = Vector2.ONE
var _speed = 30

func _process(delta):
	if isFiring:
		translate(_direction * _speed * delta)

func fire(direction:Vector2, speed: float):
	isFiring = true
	_direction = direction
	_speed = speed
	pass
