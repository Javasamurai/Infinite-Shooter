extends Control

var global

func _ready():
	global = get_node("/root/Globals")
	pass

func _on_home_btn_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Nodes/MainMenu.tscn")
	pass


func _on_retry_btn_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Nodes/Root.tscn")
	pass


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.playing = false
	pass


func _on_game_over_hide():
	pass # Replace with function body.


func _on_game_over_visibility_changed():
	if visible:
		$score.text = "Score:" + str(global.saved_data["score"])
		$waves.text = "You have survived:" + str(global.current_wave) + " wave"
	pass
