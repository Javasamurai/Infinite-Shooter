extends Sprite

var area_2d
var time_elapsed = 0
#var Bullets
var DIRECTION = "DOWN"
var angle = 0
var is_firing = false
var fire_speed = 0
enum type {
	NORMAL,
	MISSILE,
	FIREBALL,
	RADIAL,
	RANDOM
}
var radius = 0
var global
var tween
var already_hit = false

var a = 0

func _ready():
	set_physics_process(true)
	global = get_node("/root/Globals")
	area_2d = $bullet_area
	area_2d.connect("area_entered",self,"_on_bullet_hit")
	#Bullets = get_parent().get("Bullets")
	tween = get_node("Tween")
	fade_again()
	pass

func fade_again():
	tween.interpolate_property($".", "modulate", Color.white,Color(1,1,1,0.75),0.25,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
	tween.start()
	
func set_bullet_texture(path):
	set_texture(load(str(path)))
	pass

func _process(delta):
	if is_firing:
		
		#Vector2(self.position.x - (fire_speed * delta), self.position.y - (fire_speed * delta))
		#offset = Vector2(offset.x + (fire_speed * delta), offset.y  + (fire_speed * delta))
		#a += 25 * delta
		#a = angle
		#radius = (fire_speed * delta) 
		#radius = 20
		#position = Vector2(position.x + sin(a) * radius, position.y + cos(a) * radius)
		#position = Vector2( position.x + sin(a) * radius, position.y + cos(a) * radius)

		#if self.rotation != 0:
			#if self.rotation > 0:
			#	self.position.x = self.position.x + (75 * delta)
			#else:
			#	self.position.x = self.position.x - (75 * delta)
			#pass
			
			#if self.rotation >= 0 && self.rotation < 90:
			#	DIRECTION = "LEFT"
			#elif self.rotation >= 90 && self.rotation < 180:
			#	DIRECTION = "UP"
			#elif self.rotation >= 90 && self.rotation < 180:
			#	DIRECTION = "UP"
			#elif self.rotation >= 180  && self.rotation < 360:
			#	DIRECTION = "DOWN"


		if DIRECTION == "UP":
			self.position = Vector2(self.position.x, self.position.y - (fire_speed * delta))
		elif DIRECTION == "DOWN":
			self.position = Vector2(self.position.x, self.position.y + (fire_speed * delta))
		elif DIRECTION == "LEFT":
			self.position = Vector2(self.position.x - (fire_speed * delta), self.position.y)
		elif DIRECTION == "RIGHT":
			self.position = Vector2(self.position.x + (fire_speed * delta), self.position.y)
		elif DIRECTION == "TOP_LEFT":
			self.position = Vector2(self.position.x - (fire_speed * delta), self.position.y - (fire_speed * delta))
		elif DIRECTION == "TOP_RIGHT":
			self.position = Vector2(self.position.x + (fire_speed * delta), self.position.y - (fire_speed * delta))
		elif DIRECTION == "BOTT_LEFT":
			self.position = Vector2(self.position.x - (fire_speed * delta), self.position.y + (fire_speed * delta))
		elif DIRECTION == "BOTT_RIGHT":
			self.position = Vector2(self.position.x + (fire_speed * delta), self.position.y + (fire_speed * delta))

	time_elapsed+= delta
	# remove after 10 seconds
	#if time_elapsed > 10:
	#	self.queue_free()


func fire(_direction, _fire_speed):
	is_firing = true
	DIRECTION = _direction
	fire_speed = _fire_speed
	pass
	
func fireAngle(_angle, _fire_speed):
	is_firing = true
	angle = _angle
	fire_speed = _fire_speed
	pass

func _on_bullet_hit(body):
	if body == $bullet_body:
		return

	var _node_name = self.name
	var area_name = body.name
	return

	var isPlayer_bullet = _node_name.find("player_bullet") != -1
	var isEnemy_bullet = _node_name.find("enemy_bullet") != -1
	var hitPlayer_body = (area_name.find("player_area") != -1)
	var hitEnemy_body = (area_name.find("enemy_area") != -1)
	# some flashy animation of destroying

	if (isPlayer_bullet && hitEnemy_body) || (isEnemy_bullet && hitPlayer_body):
		body.get_node("../").hit()
		already_hit = true

		$bullet_area.hide()
		$bullet_area.disconnect("area_entered",self, "_on_bullet_hit")
		queue_free()
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass
