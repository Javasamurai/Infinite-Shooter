extends ScrollContainer

var selected_plane = 3

export(NodePath) var price_path

var price_lbl
func _ready():
	price_lbl = get_node(price_path)
	pass

func scrollStarted():
	#print(scroll_vertical)	
	pass

func toMainMenu():
	get_tree().change_scene("res://Nodes/MainMenu.tscn")
	pass

func onPlaneEntered(area):
	get_node("../plane_info").text = area.get_node("..").name
	$HBoxContainer/Tween.interpolate_property(area.get_node(".."), "rect_scale", Vector2.ONE, Vector2(1.5,1.5), 0.25, Tween.TRANS_BOUNCE)
	$HBoxContainer/Tween.start()
	
	Input.vibrate_handheld(20)
	price_lbl.text = area.get_node("..").name.right(area.get_node("..").name.length() - 1) + "000"
	pass

func onPlaneExited(area):
	$HBoxContainer/Tween.interpolate_property(area.get_node(".."), "rect_scale", Vector2(1.5,1.5), Vector2.ONE, 0.25, Tween.TRANS_BOUNCE)
	$HBoxContainer/Tween.start()
	pass
