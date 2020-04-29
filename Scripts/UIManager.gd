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
var earth_node
var plane_tween
var flames_lvl_3_left
var flames_lvl_3_right
var time_spent

export(NodePath) var earth

func _ready():
	set_process(true)
	time_spent = 0
	button_click = find_node("ButtonClick")
	plane_node = find_node("Selected_ship")
	plane_tween = plane_node.get_node("Tween")
	title = find_node("title")
	earth_node = get_node(earth)
	
	global = get_node("/root/Globals")
	left_arrow = find_node("left_arrow", true, true)
	right_arrow = find_node("right_arrow")
	flames_lvl_3_left = find_node("flames_lvl_3_left")
	flames_lvl_3_right = find_node("flames_lvl_3_right")
	var rot_tween = earth_node.get_node("Tween")
	rot_tween.interpolate_property(earth_node, "rotation_degrees", 0, 36000, 1500,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	rot_tween.start()

	if global.selected_plane == 1:
		left_arrow.disabled = true
	if global.selected_plane == 3:
		right_arrow.disabled = true

	if global.over:
		get_node("/root/Control/AudioManager/death").play()
		global.over = false
		title.set_text("Game Over")
	pass

func _process(delta):
	time_spent+= delta
	if global.selected_plane == 3:
		print(time_spent)
		if time_spent > 1.25 and flames_lvl_3_left.visible == false:
			flames_lvl_3_left.visible = true
			flames_lvl_3_right.visible = true
			plane_node.set_texture(load("res://Images/level_" + str(global.selected_plane) + "_05.png"))

func _on_arrow_pressed(_direction):
	button_click.play()
	
	if _direction == direction.LEFT:
		right_arrow.disabled = false
		if global.selected_plane > 1:
			left_arrow.disabled = false
			global.selected_plane = global.selected_plane - 1
		else: 
			left_arrow.disabled = true
	
	if _direction == direction.RIGHT:
		left_arrow.disabled = false
		if global.selected_plane < 3:
			right_arrow.disabled = false
			global.selected_plane = global.selected_plane +1
		else:
			right_arrow.disabled = true
		pass
	var tex = null
	if global.selected_plane == 3:
		time_spent = 0
		var texture = {
			1: load("res://Images/level_" + str(global.selected_plane) + "_01.png"),
			2: load("res://Images/level_" + str(global.selected_plane) + "_02.png"),
			3: load("res://Images/level_" + str(global.selected_plane) + "_03.png"),
			4: load("res://Images/level_" + str(global.selected_plane) + "_04.png"),
			5: load("res://Images/level_" + str(global.selected_plane) + "_05.png")
		}
		flames_lvl_3_left.visible = false
		flames_lvl_3_right.visible = false

		var anim_tex = AnimatedTexture.new()
		anim_tex.set_frames(4)
		anim_tex.set_fps(3)
		anim_tex.set_frame_texture(0, texture[1])
		anim_tex.set_frame_texture(1, texture[2])
		anim_tex.set_frame_texture(2, texture[3])
		anim_tex.set_frame_texture(3, texture[4])
		anim_tex.set_frame_texture(4, texture[5])
		plane_node.set_texture(anim_tex)
	else:
		tex = load("res://Images/UI_Level_" + str(global.selected_plane) + "_Plane.png")
		plane_node.set_texture(tex)
		flames_lvl_3_left.visible = false
		flames_lvl_3_right.visible = false
	pass

func switch_scene():
	get_tree().change_scene("res://Nodes/Root.tscn")
	pass

func switching_finished(_object, _key):
	#tween.interpolate_property(plane_node, "transform/pos", plane_node.pos, Vector2(-1000, plane_node.pos.y), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()
	pass

func _on_right_arrow_pressed():
	_on_arrow_pressed(direction.RIGHT)

func _on_left_arrow_pressed():
	_on_arrow_pressed(direction.LEFT)
	pass
