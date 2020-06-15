extends "res://Scripts/EnemyController.gd"

var path_controller
func _ready():
	is_active = false

	path_controller = get_node("..")
	enemy_selected_config = {
		"key": 100,
		"name": "crazy",
		"bullet_type": "normal",
		"canRotate": false,
		"smart": false,
		"canShoot": false,
		"speed": 50,
		"chaseDelay": 2.0,
		"fireDelayMin": 2.5,
		"fireDelayMax": 2.5,
		"bullet_speed": 300,
		"health": 50,
		"chaseX": false,
		"chaseY": false
	}
	fireDelay = enemy_selected_config["fireDelayMax"]
	set_process(true)

	pass
	
func _process(delta):
	time_elapsed+=delta
	if time_elapsed > fireDelay && canShoot:
		time_elapsed = 0
		fire()
	path_controller.offset = (path_controller.offset + speed * delta)
	if path_controller.unit_offset >= 1:
		get_node("../..").queue_free()
	pass


func _on_explosion_animation_finished():
	get_node("../..").queue_free()
	queue_free()
	pass
