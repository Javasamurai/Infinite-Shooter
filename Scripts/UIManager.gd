extends Control

enum direction { LEFT,RIGHT }
export(direction) var dir = direction.LEFT
export(NodePath) var button_click
var tween

func _ready():
	#tween = get_node("Tween")
	#tween.interpolate_property($"../Selected_ship", "position", Vector2(0,0), Vector2(100, 0), 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.interpolate_property($"../Selected_ship", "position", Vector2(0,0), Vector2(100, 0), 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()
	pass

func _on_arrow_pressed():
	get_node(button_click).play()
	if dir == direction.LEFT:
		print("LEFT")
	elif dir == direction.RIGHT:
		print("RIGHT")
	pass


func switch_scene():
	get_tree().change_scene("res://Nodes/Root.tscn")
	pass # Replace with function body.
