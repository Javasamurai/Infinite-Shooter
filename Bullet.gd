extends Sprite

var area_2d
var time_elapsed = 0
var Bullets
var DIRECTION = "DOWN"
var is_firing = false
var fire_speed = 0
var global
var tween

func _ready():
	set_physics_process(true)
	global = get_node("/root/Globals")
	area_2d = $bullet_area
	area_2d.connect("area_entered",self,"_on_bullet_hit")
	Bullets = get_parent().get("Bullets")
	tween = get_node("Tween")
	#var tex = load("res://Images/Level_01_Bullet.png")
	#set_texture(tex)
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
		if DIRECTION == "UP":
			self.position = Vector2(self.position.x, self.position.y - (fire_speed * delta))
		else:
			self.position = Vector2(self.position.x, self.position.y + (fire_speed * delta))

	time_elapsed+= delta
	# remove after 10 seconds
	#if time_elapsed > 10:
	#	self.queue_free()


func fire(_direction, _fire_speed):
	is_firing = true
	DIRECTION = _direction
	fire_speed = _fire_speed

func _on_bullet_hit(areas):
	var node_name = self.name
	var area_name = areas.name
	var isPlayer_bullet = area_name.find("enemy_area") != -1
	var isEnemy_bullet = area_name.find("player_area") != -1
	var hitPlayer_bullet = (node_name.find("enemy_bullet") != -1 && isPlayer_bullet)
	var hitEnemy_bullet = (node_name.find("player_bullet") != -1 && isEnemy_bullet)
	# some flashy animation of destroying
	
	#if hitEnemy_bullet:
	#	queue_free()
	#if hitPlayer_bullet:
	#	queue_free()

	if !hitPlayer_bullet && !hitEnemy_bullet && (isPlayer_bullet or isEnemy_bullet):
		if isPlayer_bullet:
			areas.get_node("../").hit()
		$bullet_area.hide()
		$death.play()
		if isEnemy_bullet:
			areas.get_node("../").hit()
	pass

func _on_music_finished():
	queue_free()
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass
