extends "res://Agent.gd"

var velocity = Vector2.ZERO
var angular_velocity = 0
var canFire:bool = false
var time_elapsed:float = 0
var fire_delay = 1

enum CHASE_TYPES {
	TURRET,
	FACE_CHASE,
	DUMB,
	FOLLOW_PATH
}

export(CHASE_TYPES) var chase_type = CHASE_TYPES.TURRET
export var speed_max := 450
export var acc_max := 80
export var angular_speed_max := 240
export var angular_acc_max := 70

onready var bulletInstance = load("res://Revamp/Nodes/Bullet.tscn")
var acceleration = GSAITargetAcceleration.new()

onready var priority = GSAIPriority.new(agent)
onready var player:Node = get_tree().get_nodes_in_group("Player")[0]
onready var pursue_blend := GSAIBlend.new(agent)
onready var flee_blend := GSAIBlend.new(agent)

onready var player_agent : GSAISteeringAgent = player.agent
onready var proximity := GSAIRadiusProximity.new(agent, [player_agent], 2)
onready var avoid := GSAIAvoidCollisions.new(agent, proximity)


var bounds = Vector2(ProjectSettings["display/window/size/width"], ProjectSettings["display/window/size/height"])

var bulletSpawners = []

func _ready():
	$BulletSpawner.autofire = active
	enemy = true
	set_physics_process(true)
	
	for n in range(0, get_child_count()):
		if get_child(n) is BulletSpawner:
			bulletSpawners.append(get_child(n))

	if active:
		setup()
		setBulletSpawners(true)
	else:
		$bg.visible = false
		$CollisionShape2D.disabled = true
		setBulletSpawners(false)
	pass

func setBulletSpawners(fire):
	for spawners in bulletSpawners:
		spawners.autofire = fire
	pass
	

func setup():
	$bg.visible = true
	$BulletSpawner.autofire = true
	$CollisionShape2D.disabled = false

	agent.angular_speed_max = deg2rad(angular_speed_max)
	agent.angular_acceleration_max = deg2rad(angular_acc_max)
	agent.linear_speed_max = speed_max
	agent.linear_acceleration_max = acc_max
	#var shape = $CollisionShape2D.shape as RectangleShape2D
	#agent.bounding_radius = shape.extents.x
	
	agent.bounding_radius = 4

	var look := GSAILookWhereYouGo.new(agent)
	look.alignment_tolerance = deg2rad(5)
	look.deceleration_radius = deg2rad(136)

	#var evade := GSAIEvade.new(agent, player_agent, 2.5)
	#var flee := GSAIFlee.new(agent, player_agent)
	#flee_blend.is_enabled = false
	#flee_blend.add(look, 1)
	#flee_blend.add(evade, 1)

	var persue := GSAIPursue.new(agent, player_agent)
	persue.predict_time_max = 1.5
	pursue_blend.is_enabled = true

	var orient_behavior := GSAIFace.new(agent, player_agent)
	orient_behavior.alignment_tolerance = deg2rad(0)
	orient_behavior.deceleration_radius = deg2rad(136)
	
	pursue_blend.add(orient_behavior, 1)
	
	if chase_type == CHASE_TYPES.FACE_CHASE:
		pursue_blend.add(persue, 1)
	priority.add(avoid)
	#priority.add(flee_blend)
	priority.add(pursue_blend)
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

func _physics_process(delta):
	if !active:
		return

	#if health <= 50:
		#pursue_blend.is_enabled = false
		#flee_blend.is_enabled = true

	if !$BulletSpawner.autofire:
		setup()
		$BulletSpawner.autofire = true
	if chase_type != CHASE_TYPES.DUMB:
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
	else:
		move_and_slide(Vector2(0, speed_max * delta * 10))
	pass
