extends Control

var global

func _ready():
	global = get_node("/root/Globals")

	$score.text = "Score:" + str(global.saved_data["score"])
	$waves.text = "You have survived:" + str(global.current_wave) + " wave"
	pass
