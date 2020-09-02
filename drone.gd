extends AnimatedSprite


var activated = false
var exploded = false
var target = null

#var tween
var	bullet
var left = true

export var positioning = "left"

func _ready():
	if positioning == "left":
		$Tween.interpolate_method(self, "set_position", self.position, Vector2(position.x - 5, position.y), 1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	else:
		$Tween.interpolate_method(self, "set_position", self.position, Vector2(position.x + 5, position.y), 1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		left = true


	$Tween.start()

	bullet = preload("res://Nodes/Bullet.tscn")
	$Area2D.connect("area_entered", self, "drone_hit")
	set_physics_process(true)

	
	pass

func activate(_target):
	target = _target
	$Timer.start()
	activated = true
	pass

func _physics_process(delta):
	if is_instance_valid(target) && activated:
		chaseTarget(delta)

func chaseTarget(delta):
	return
	#if tween != null:
		#var move = Vector2.ZERO
		#$Timer.start(3)
		#if position.y > 200:
		#position != target.position && :
			#var size = 40 / 2
		#move = position.move_toward(target.position, delta)
		#move = move.normalized()
		#if move.y < 0:
		#	position += move
	#pass

func drone_hit(area):
	if area.name == "enemy_area" && activated:
		area.get_node("../").hit(true)
		explode()
	pass

func explode():
	exploded = true
	$Explosion.visible = true
	$Timer.wait_time = 0.15
	$Timer.start()
	pass

func fire():
	var bullet_clone = bullet.instance()

	#bullet_clone.position = Vector2(get_node("..").position.x, get_node("..").position.y)
	bullet_clone.position = self.global_position
	bullet_clone.fire("UP", 500)
	bullet_clone.name = "player_bullet_drone"
	get_node("../..").add_child(bullet_clone)
	pass
#func explosion_done():
#	if !exploded:
#		explode()
#	else:
#		queue_free()
#	pass


func _on_drone_animation_finished():
	if positioning == "left":
		if left:
			$Tween.interpolate_method(self, "set_position", position, Vector2(position.x + 5, position.y), 1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			left = false
		else:
			$Tween.interpolate_method(self, "set_position", position, Vector2(position.x - 5, position.y), 1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			left = true
	else:
		if left:
			$Tween.interpolate_method(self, "set_position", position, Vector2(position.x - 5, position.y), 1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			left = false
		else:
			$Tween.interpolate_method(self, "set_position", position, Vector2(position.x + 5, position.y), 1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			left = true

	#else:
	#	$Tween.interpolate_method(self, "set_position", position, Vector2(position.x + 10, position.y) , 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	#	left = true

	$Tween.start()
	pass
