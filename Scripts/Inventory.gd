extends Control

var selected_plane = 3
var price_lbl
var plane_clone

var plane_node


func _ready():
	$moon/moon_tween.interpolate_property($moon, "rect_rotation", 0, 36000, 1500,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$moon/moon_tween.start()
	plane_node = preload("res://Nodes/inventory_plane.tscn")
	
	for i in range(6):
		plane_clone = plane_node.instance()
		plane_clone.rect_position = Vector2.ZERO
		#plane_clone.rect_position = Vector2( i * 70, 0)
		plane_clone.name = "Plane " + str(i + 1)
		plane_clone.texture = load("res://Images/UI_Planes/UI_Level_" + str(i + 1) + "_Plane.png")
	
		$ScrollContainer/Control.add_child(plane_clone)
	#$ScrollContainer/Control.rect_size = Vector2($ScrollContainer/Control.get_child_count() * 80, 50)
	pass

func scrollStarted():
	#print(scroll_vertical)	
	pass

func toMainMenu():
	get_tree().change_scene("res://Nodes/MainMenu.tscn")
	pass

func onPlaneEntered(area):
	$plane_info.text = area.get_node("..").name
	$Tween.interpolate_property(area.get_node(".."), "rect_scale", Vector2.ONE, Vector2(1.25,1.25), 0.1, Tween.EASE_IN_OUT)
	$Tween.start()
	Input.vibrate_handheld(50)
	$buy_button/price.text = area.get_node("..").name.right(area.get_node("..").name.length() - 1) + "000"
	pass

func onPlaneExited(area):
	$Tween.interpolate_property(area.get_node(".."), "rect_scale", rect_scale, Vector2.ONE, 0.1, Tween.EASE_IN_OUT)
	$Tween.start()
	pass
