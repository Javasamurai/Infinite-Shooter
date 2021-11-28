extends KinematicBody2D

export var health = 100
onready var agent := GSAISteeringAgent.new()
onready var kinematic_agent := GSAIKinematicBody2DAgent.new(self)

export var enemy = false
export var active = false


var velocity = Vector2.ZERO
var angular_velocity = 0

export var speed_max := 450
export var acc_max := 400
export var angular_speed_max := 240
export var angular_acc_max := 70

var bounds = Vector2(ProjectSettings["display/window/size/width"], ProjectSettings["display/window/size/height"])

var default_animation
export(NodePath) var explosionPath
var explosion

enum CHASE_TYPES {
	TURRET,
	FACE_CHASE,
	DUMB,
	FOLLOW_PATH,
	ARRIVE
}

export(CHASE_TYPES) var chase_type = CHASE_TYPES.TURRET

var screen_width = OS.get_screen_size().x
var screen_height = OS.get_screen_size().y

func _ready():
	set_physics_process(true)
	default_animation = $bg.animation

	agent.orientation = rotation
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

func hit(damage):
	health -= damage
	if enemy:
		$bg.animation = default_animation + "_hit"
		yield(get_tree().create_timer(0.05),"timeout")
		$bg.animation = default_animation	
		
		move_and_slide(Vector2(0, -25))
		get_tree().paused = true
		yield(get_tree().create_timer(0.01),"timeout")
		move_and_slide(Vector2(0, 25))
		get_tree().paused = false
	else:
		move_and_slide(Vector2(0, 50))
	if health <= 0 && position.y <= screen_width && position.y >= 0 && active:
		active = false
		EventBus.emit_signal("spawnCoinAt", self.global_position, 0.25)
		if explosion != null:
			explosion.visible = true
			explosion.playing = true
		yield(get_tree().create_timer(.5),"timeout")
		queue_free()
	pass
