extends Control

var selected_plane = 3
var price_lbl
var plane_clone

var plane_node
var global
var currentNodeInside

func _ready():
	global = get_node("/root/Globals")
	$moon/moon_tween.interpolate_property($moon, "rect_rotation", 0, 36000, 1500,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$moon/moon_tween.start()
	plane_node = preload("res://Nodes/inventory_plane.tscn")

	if !global.isDroneInventory:
		for i in range(8):
			plane_clone = plane_node.instance()
			plane_clone.rect_position = Vector2.ZERO
			plane_clone.name = "Plane " + str(i + 1)
			plane_clone.texture = load("res://Images/UI_Planes/UI_Level_" + str(i + 1) + "_Plane.png")
		
			$Control.add_child(plane_clone)
	else:
		for i in range(5):
			plane_clone = plane_node.instance()
			plane_clone.rect_position = Vector2.ZERO
			plane_clone.name = "Plane " + str(i + 1)
			plane_clone.index = i
			plane_clone.texture = load("res://Images/Drone/Drone_level_0" + str(i + 1) + ".png")
		
			$Control.add_child(plane_clone)


	pass

func toMainMenu():
	get_tree().change_scene("res://Nodes/MainMenu.tscn")
	pass

func onPlaneEntered(area):
	var plane = area.get_node("..")
	$plane_info.text = plane.name
	currentNodeInside = plane
	currentNodeInside.selected = true
	$buy_button/price.text = area.get_node("..").name.right(area.get_node("..").name.length() - 1) + "000"
	pass

func onPlaneExited(area):
	currentNodeInside.selected = false
	pass


func _on_buy_button_button_up():
	global.selected_plane = currentNodeInside.get_index()
	print("purchased:" + str(global.selected_plane))
	pass
