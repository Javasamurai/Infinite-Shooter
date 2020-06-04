extends Control

func _on_back_btn_gui_input(event):
	print(event)
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		get_tree().change_scene("res://Nodes/MainMenu.tscn")
	pass
