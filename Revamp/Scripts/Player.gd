extends "res://Agent.gd"

onready var bulletInstance = load("res://Revamp/Nodes/Bullet.tscn")
export(NodePath) var serverPath
export(NodePath) var spawnerPath
export(NodePath) var firePath
export var fire_delay = 0.15
export(NodePath) var hitAudioPath
export(NodePath) var explodeAudioPath

var hitAudio
var canFire:bool = false
var time_elapsed:float = 0
var spawner
var server
var fireAudio
var explodeAudio
var holding_touch = false

signal hit(health)

func _ready():
	enemy = false
	set_process_input(true)
	spawner = get_node(spawnerPath)
	server = get_node(serverPath)
	fireAudio = get_node(firePath)
	hitAudio = get_node(hitAudioPath)
	explodeAudio = get_node(explodeAudioPath)

	canFire = true
	pass


func _process(delta):
	if time_elapsed > fire_delay:
		canFire = true
	else:
		canFire = false
	time_elapsed+=delta

	if holding_touch:
		fire()


func _physics_process(delta):
	update_agent()

func _input(event):
	if event is InputEventScreenDrag:
		holding_touch = true
		if event.relative.x != 0:
			translate(event.relative)
	if event is InputEventScreenTouch:
		holding_touch = event.is_pressed()
func fire():
	if !canFire:
		return
	#var clonedBullet = bulletInstance.instance()
	#get_parent().add_child(clonedBullet)
	
	#clonedBullet.global_position = global_position
	#clonedBullet.fire(Vector2(0, -1), 500)
	time_elapsed = 0
	#server.spawn_bullet(spawner.bullet_type, global_position,  Vector2(0, -1))
	spawner.fire()
	fireAudio.play()
	pass

func update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.orientation = rotation

func _on_BulletServer_collision_detected(bullet, colliders):
	var bullet_type = bullet.get_type()
		
	if ( (bullet_type.custom_data["enemy"] && !colliders[0].enemy) || (!bullet_type.custom_data["enemy"] && colliders[0].enemy)):
		colliders[0].hit(bullet_type.damage)
		if (!colliders[0].enemy):
			emit_signal("hit", colliders[0].health)

		if colliders[0].health <= 0:
			explodeAudio.play()
		else:
			hitAudio.play()
	pass
