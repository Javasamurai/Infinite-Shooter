extends AnimatedSprite

var bullet
export var movementSpeed = 20
export var bulletSpeed = 75
var canShoot = false

var directions = [
	"UP",
	"DOWN",
	"RIGHT",
	"LEFT",
	"RANDOM"
]
var firstTexture
var size

func _ready():
	set_process(true)
	bullet = preload("res://Nodes/Bullet.tscn")
	firstTexture = frames.get_frame("1", 1)
	size = firstTexture.get_size()
	
	$Bullet.global_position = Vector2(global_position.x, global_position.y)

	$Bullet.fire("UP", bulletSpeed)
	
	pass

func _process(delta):
	position = Vector2(position.x + 0 * delta, position.y + movementSpeed * delta)
	pass

func testBullet():
	if !canShoot:
		return
	#createBullet("UP")
	#createBullet("DOWN")
	#createBullet("RIGHT")
	#createBullet("LEFT")

	#createBullet("TOP_RIGHT")
	#createBullet("TOP_LEFT")
	#createBullet("BOTT_RIGHT")
	#createBullet("BOTT_LEFT")
	#for i in range(1, 360, 15):
	#	createBullet("RIGHT", i)
pass

func createBullet(dir, angle = 0):
	var bullet_clone = bullet.instance()
	#var _dir = directions[randi() % 4]

	bullet_clone.rotation = angle
	


	bullet_clone.global_position = Vector2(global_position.x, global_position.y)
	bullet_clone.name = "enemy_bullet"
	get_parent().add_child(bullet_clone)
	bullet_clone.fireAngle(angle, bulletSpeed)
	pass

func toggleShoot():
	canShoot = !canShoot
pass
