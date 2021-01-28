extends KinematicBody2D

var health = 100
onready var agent = GSAISteeringAgent.new()
export var enemy = false
export var active = false

func _ready():
	set_physics_process(true)
	pass

func hit(damage):
	health -= damage
	if health <=0:
		queue_free()
	pass
