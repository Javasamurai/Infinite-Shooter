extends "res://Agent.gd"

var velocity = Vector2.ZERO
var angular_velocity = 0
var canFire:bool = false
var time_elapsed:float = 0
var fire_delay = 1

export var speed_max := 450
export var acc_max := 80
export var angular_speed_max := 240
export var angular_acc_max := 70


onready var bulletInstance = load("res://Revamp/Nodes/Bullet.tscn")
var acceleration = GSAITargetAcceleration.new()

onready var priority = GSAIPriority.new(agent)
onready var player:Node = get_tree().get_nodes_in_group("Player")[0]
onready var pursue_blend := GSAIBlend.new(agent)
onready var player_agent : GSAISteeringAgent = player.agent

var bounds = Vector2(ProjectSettings["display/window/size/width"], ProjectSettings["display/window/size/height"])

func _ready():
	enemy = true
	agent.angular_speed_max = deg2rad(angular_speed_max)
	agent.angular_acceleration_max = deg2rad(angular_acc_max)
	agent.linear_speed_max = speed_max
	agent.linear_acceleration_max = acc_max
	var shape = $CollisionShape2D.shape as RectangleShape2D
	#agent.bounding_radius = shape.extents.x
	agent.bounding_radius = 0
	var persue := GSAIPursue.new(agent, player_agent)
	persue.predict_time_max = 0.5
	pursue_blend.is_enabled = true
	pursue_blend.add(persue, 1)
	priority.add(pursue_blend)
	set_physics_process(true)
	pass

func update_agent():
	global_position.x = clamp(global_position.x, 0, bounds.x)
	global_position.y = clamp(global_position.y, 0,bounds.y)


	agent.position.x =  global_position.x
	agent.position.y = global_position.y
	agent.orientation = rotation
	agent.linear_velocity.x = velocity.x
	agent.linear_velocity.y = velocity.y
	agent.angular_velocity = angular_velocity
	pass

func fire():
	if !canFire:
		return
	var clonedBullet = bulletInstance.instance()
	get_parent().add_child(clonedBullet)
	
	clonedBullet.global_position = global_position
	clonedBullet.fire(Vector2(0, 1), 75)
	#time_elapsed = 0

#func _process(delta):
	
#	if time_elapsed > fire_delay:
#		canFire = true
#		fire()
#	else:
#		canFire = false
#	time_elapsed+=delta
#	pass


func _physics_process(delta):
	priority.calculate_steering(acceleration)
	velocity = (velocity + Vector2(acceleration.linear.x, acceleration.linear.y) * delta).clamped(agent.linear_speed_max)
	update_agent()
	velocity = velocity.linear_interpolate(Vector2.ZERO, 0.1)
	velocity = move_and_slide(velocity)
	
	# We then do something similar to apply our agent's rotational speed.
	angular_velocity = clamp(
		angular_velocity + acceleration.angular * delta, -agent.angular_speed_max, agent.angular_speed_max
	)
	# This applies drag on the agent's rotation, helping it slow down naturally.
	angular_velocity = lerp(angular_velocity, 0, 0.1)
	rotation += angular_velocity * delta
	pass

