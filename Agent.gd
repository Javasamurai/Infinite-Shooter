extends KinematicBody2D

export var health = 100
onready var agent = GSAISteeringAgent.new()
export var enemy = false
export var active = false

var default_animation
onready var coin_node
export(NodePath) var explosionPath
var explosion

var screen_width = OS.get_screen_size().x
var screen_height = OS.get_screen_size().y

func _ready():
	coin_node = load("res://Revamp/Nodes/coin.tscn")
	set_physics_process(true)
	default_animation = $bg.animation
	if explosionPath != null && explosionPath != "":
		explosion = get_node(explosionPath)
		
	pass

func hit(damage):
	health -= damage
	if enemy:
		$bg.animation = default_animation + "_hit"
		yield(get_tree().create_timer(0.05),"timeout")
		$bg.animation = default_animation	
		#var coin_clone = coin_node.instance()
		#coin_clone.position = self.global_position
		#coin_clone.active = true
		#get_node("../..").add_child(coin_clone)
		move_and_slide(Vector2(0, -25))
		get_tree().paused = true
		yield(get_tree().create_timer(0.01),"timeout")
		move_and_slide(Vector2(0, 25))
		get_tree().paused = false
	else:
		move_and_slide(Vector2(0, 50))
	if health <= 0 && position.y <= screen_width && position.y >= 0 && active:
		active = false
		if explosion != null:
			explosion.visible = true
			explosion.playing = true
		yield(get_tree().create_timer(.5),"timeout")
		queue_free()
	pass
