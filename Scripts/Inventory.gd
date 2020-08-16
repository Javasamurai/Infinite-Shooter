extends Control

var selected_plane = 3
var price_lbl
var plane_clone

var plane_node


func _ready():
	$moon/moon_tween.interpolate_property($moon, "rect_rotation", 0, 36000, 1500,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$moon/moon_tween.start()
	plane_node = preload("res://Nodes/inventory_plane.tscn")
	
	for i in range(10):
		plane_clone = plane_node.instance()
		plane_clone.rect_position = Vector2( i * 70, 0)
		$ScrollContainer/Control.add_child(plane_clone)
	$ScrollContainer/Control.rect_size = Vector2($ScrollContainer/Control.get_child_count() * 80, 50)
	pass

func scrollStarted():
	#print(scroll_vertical)	
	pass

func toMainMenu():
	get_tree().change_scene("res://Nodes/MainMenu.tscn")
	pass

func onPlaneEntered(area):
	$plane_info.text = area.get_node("..").name
	$Tween.interpolate_property(area.get_node(".."), "rect_scale", Vector2.ONE, Vector2(1.5,1.5), 0.15, Tween.EASE_IN)
	$Tween.start()
	Input.vibrate_handheld(50)
	$buy_button/price.text = area.get_node("..").name.right(area.get_node("..").name.length() - 1) + "000"
	pass

func onPlaneExited(area):
	$Tween.interpolate_property(area.get_node(".."), "rect_scale", Vector2(1.5,1.5), Vector2.ONE, 0.15, Tween.EASE_OUT)
	$Tween.start()
	pass
