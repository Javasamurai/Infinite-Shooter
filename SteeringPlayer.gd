extends Sprite


onready var agent = GSAISteeringAgent.new()

func _ready():
	set_physics_process(true)
	pass
	
func _physics_process(delta):
	update_agent()
	pass

func _input(event):
	if event is InputEventScreenDrag:
		position = event.position

func update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.orientation = rotation
	#agent.linear_velocity.x = self.velocity.x
	#agent.linear_velocity.y = self.velocity.y
	#agent.angular_velocity = self.angular_velocity
