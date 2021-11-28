extends "res://Agent.gd"

onready var bulletInstance = load("res://Revamp/Nodes/Bullet.tscn")
export(NodePath) var serverPath
export(NodePath) var spawnerPath

export var fire_delay = 0.15

var canFire:bool = false
var time_elapsed:float = 0
var spawner
var server

var holding_touch = false
onready var selected_plane = str(Globals.selected_plane) 
onready var tween = get_node("Tween")
signal hit(health)

func _ready():
	enemy = false
	agent.bounding_radius = 30
	set_process_input(true)
	spawner = get_node(spawnerPath)
	server = get_node(serverPath)
	$bg.animation = selected_plane
	canFire = true
	var centerX = (bounds.x / 2) - 30
	tween.interpolate_property(self, "position", Vector2( centerX, bounds.y), Vector2( centerX, bounds.y - 50), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	set_physics_process(true)
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
	for i in get_slide_count():
		var collidedBodies = get_slide_collision(i)

		if collidedBodies.collider == null:
			return

		if collidedBodies.collider.has_meta("enemy"):
			if collidedBodies.collider.enemy:
				hit(10)
		if collidedBodies.collider.name == "coin":
			EventBus.emit_signal("playAudio", "coin")
			EventBus.emit_signal("got_coin")
			collidedBodies.collider.queue_free()
	pass

func _input(event):
	if event is InputEventScreenDrag:
		holding_touch = true
		if event.relative.x != 0:
			#if event.relative.x < 0:
				#$Tween.interpolate_property(get_node("."), "rotation_degrees", 0,-2,0.1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
				#$Tween.start()
			#else:
				#$Tween.interpolate_property(get_node("."), "rotation_degrees", 0,2,0.1,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
				#$Tween.start()
			translate(event.relative)
	if event is InputEventScreenTouch:
		holding_touch = event.is_pressed()

func fire():
	if !canFire:
		return
	move_and_slide(Vector2(0, 10))
	time_elapsed = 0

	$BulletSpawner.fire()
	$BulletSpawner2.fire()
	EventBus.emit_signal("playAudio", "fire")
	$bg.animation = selected_plane + "_muzzle"
	yield(get_tree().create_timer(0.1),"timeout")
	$bg.animation = selected_plane
	move_and_slide(Vector2(0, -8))
	pass

func update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.orientation = rotation


func _on_BulletServer_collision_detected(bullet, colliders):
	var bullet_type = bullet.get_type()

	for collided_body in colliders:
		if !"active" in collided_body:
			return
		if !collided_body.active:
			return
		if ( (bullet_type.custom_data["enemy"] && !collided_body.enemy) || (!bullet_type.custom_data["enemy"] && collided_body.enemy)):
			colliders[0].hit(bullet_type.damage)
			emit_signal("hit", colliders[0].enemy, colliders[0].health)
			if colliders[0].health <= 0:
				EventBus.emit_signal("playAudio", "explode")
			else:
				EventBus.emit_signal("playAudio", "hit")
	pass
