extends "res://Agent.gd"

signal got_coin(current_count)

var global
var coin_got = false
var magnet_radius = 75

var _acc := GSAITargetAcceleration.new()
var target := GSAIAgentLocation.new()

onready var player:Node = get_tree().get_nodes_in_group("Player")[0]
onready var arrive = GSAIArrive.new(kinematic_agent, player.agent)
onready var EventBus = get_node("/root/EventBus")

func _ready():
	global = get_node("/root/Globals")
	set_process(true)
	set_physics_process(true)
	kinematic_agent.linear_speed_max = speed_max
	kinematic_agent.linear_acceleration_max = acc_max
	kinematic_agent.linear_drag_percentage = 0.1
	arrive.arrival_tolerance = 0
	arrive.deceleration_radius = 420
	
	arrive.is_enabled = false
	pass

func _physics_process(delta):
	update_agent()
	arrive.calculate_steering(_acc)
	kinematic_agent._apply_steering(_acc, delta)

func _process(delta):
	if active:
		if player!= null:
			var distance = position.distance_to(player.position)
			
			if distance <= magnet_radius:
				arrive.is_enabled = true
			else:
				arrive.is_enabled = false
				position.y = ( position.y + (100 *  delta))
				if position.y > bounds.y:
					queue_free()
	pass

func _on_coin_body_entered(body):
	if !body.enemy:
		if !coin_got:
			coin_got = true
			global.saved_data["coins"] = global.saved_data["coins"] + 1
			EventBus.emit_signal("got_coin")
			EventBus.emit_signal("playAudio", "coin")
			queue_free()
	pass
