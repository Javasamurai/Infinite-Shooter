extends Control

enum direction { LEFT,RIGHT }
export(direction) var dir = direction.LEFT
export(NodePath) var button_click
export(NodePath) var plane
export(NodePath) var title

var tween
var global

func _ready():
	#tween = get_node("Tween")
	#tween.interpolate_property($"../Selected_ship", "position", Vector2(0,0), Vector2(100, 0), 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.interpolate_property($"../Selected_ship", "position", Vector2(0,0), Vector2(100, 0), 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()
	global = get_node("/root/Globals")
	if global.over:
		get_node("/root/Control/AudioManager/death").play()
		global.over = false
		get_node(title).set_text("Game Over")
	pass

func _on_arrow_pressed():
	get_node(button_click).play()
	print(global.selected_plane)
	if dir == direction.LEFT:
		if global.selected_plane > 0:
			global.selected_plane = global.selected_plane - 1
	elif dir == direction.RIGHT:
		if global.selected_plane < 2:
			global.selected_plane = global.selected_plane +1
		print("RIGHT")
	#var tex = load("res://Images/Players/Idle_01.png")
	#print(tex)
	var tex = load("res://Images/Players/Level_" + str(global.selected_plane) + "_Player.png")
	get_node(plane).set_texture(tex)

	#plane.set_frame_texture(0, tex)
	#plane.set_frame_texture(1, tex)
	pass


func switch_scene():
	get_tree().change_scene("res://Nodes/Root.tscn")
	pass # Replace with function body.
