extends Control

var global

func _ready():
	global = get_node("/root/Globals")

	$score.text = "Score:" + str(global.saved_data["score"])
	$waves.text = "You have survived:" + str(global.current_wave) + " wave"
	pass


func _on_home_btn_pressed():
	get_tree().change_scene("res://Nodes/MainMenu.tscn")
	pass


func _on_retry_btn_pressed():
	get_tree().change_scene("res://Nodes/Root.tscn")
	pass
