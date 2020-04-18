extends Control

enum direction {
	LEFT,
	RIGHT
}
var tween
var global
var plane_node
var left_arrow
var right_arrow
var button_click
var title

func _ready():
	button_click = find_node("ButtonClick")
	plane_node = find_node("Selected_ship")
	title = find_node("title")
	#print(plane_node.get_position_in_parent())
	global = get_node("/root/Globals")
	left_arrow = find_node("left_arrow", true, true)
	right_arrow = find_node("right_arrow")
	
	if global.selected_plane == 0:
		left_arrow.disabled = true
	if global.selected_plane == 2:
		right_arrow.disabled = true

	if global.over:
		get_node("/root/Control/AudioManager/death").play()
		global.over = false
		get_node(title).set_text("Game Over")
	pass

func _on_arrow_pressed(_direction):
	button_click.play()
	
	if _direction == direction.LEFT:
		right_arrow.disabled = false
		if global.selected_plane > 0:
			left_arrow.disabled = false
			global.selected_plane = global.selected_plane - 1
		else: 
			left_arrow.disabled = true
	
	if _direction == direction.RIGHT:
		left_arrow.disabled = false
		if global.selected_plane < 2:
			right_arrow.disabled = false
			global.selected_plane = global.selected_plane +1
		else:
			right_arrow.disabled = true
		pass

	var tex = load("res://Images/Players/Level_" + str(global.selected_plane) + "_Player.png")
	plane_node.set_texture(tex)
	pass

#func on_left_pressed():
#	var tween = plane_node.get_node("Tween")
#	tween.interpolate_property(plane_node, "transform/position", plane_node.position, Vector2(-1000, plane_node.position.y), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
#	pass

func switch_scene():
	get_tree().change_scene("res://Nodes/Root.tscn")
	pass


func switching_finished(object, key):
	#tween.interpolate_property(plane_node, "transform/pos", plane_node.pos, Vector2(-1000, plane_node.pos.y), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()
	pass

func _on_right_arrow_pressed():
	_on_arrow_pressed(direction.RIGHT)
func _on_left_arrow_pressed():
	_on_arrow_pressed(direction.LEFT)
	pass
