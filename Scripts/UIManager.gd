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
var initial_plane_pos
var music_btn
var score_lbl
var music = false
var coins_lbl

export(NodePath) var earth

func _ready():
	set_process(true)
	time_spent = 0
	button_click = find_node("ButtonClick")
	score_lbl = find_node("max_score")
	coins_lbl = find_node("coins")

	plane_node = find_node("Selected_ship")
	plane_tween = plane_node.get_node("Tween")
	music_btn = find_node("music_btn")
	plane_tween.connect("tween_all_completed",self, "switching_finished")
	title = find_node("title")
	earth_node = get_node(earth)
	
	global = get_node("/root/Globals")
	left_arrow = find_node("left_btn")
	right_arrow = find_node("right_btn")
	flames_lvl_3_left = find_node("flames_lvl_3_left")
	flames_lvl_3_right = find_node("flames_lvl_3_right")
	initial_plane_pos = plane_node.get_position_in_parent()
	fill_values()

	var rot_tween = earth_node.get_node("Tween")
	rot_tween.interpolate_property(earth_node, "rotation_degrees", 0, 36000, 1500,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	rot_tween.start()

	if global.selected_plane == 1:
		left_arrow.modulate = Color(0,0.0, 0.75)
	if global.selected_plane == 3:
		right_arrow.modulate = Color.white

	if global.over:
		if !music:
			get_node("/root/Control/AudioManager/death").play()
		global.over = false
		$game_over.visible=true
		
		$Timer.start(3)
	pass

func game_over():
	$game_over/AnimatedSprite.play()
	pass

func _process(delta):
	time_spent+= delta
	if global.selected_plane == 3:
		#print(time_spent)
		if time_spent > 1.25 and flames_lvl_3_left.visible == false:
			flames_lvl_3_left.visible = true
			flames_lvl_3_right.visible = true
			plane_node.set_texture(load("res://Images/level_" + str(global.selected_plane) + "_05.png"))

func _on_arrow_pressed(_direction):
	if !music:
		button_click.play()
	if _direction == direction.LEFT:
		right_arrow.modulate = Color.white
		if global.selected_plane > 1:
			left_arrow.modulate = Color.white
			global.selected_plane = global.selected_plane - 1

	if _direction == direction.RIGHT:
		left_arrow.modulate = Color.white
		if global.selected_plane < 3:
			right_arrow.modulate = Color.white
			global.selected_plane = global.selected_plane + 1
		else:
			right_arrow.modulate = Color(0,0.0, 0.75)
		pass
	var tex = null

	if global.selected_plane == 1:
		left_arrow.modulate = Color(0,0.0, 0.75)

	if global.selected_plane == 3:
		right_arrow.modulate = Color(0,0.0, 0.75)
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

func switch_plane(left):
	if left:
		plane_tween.interpolate_property(plane_node, "transform/pos", initial_plane_pos, Vector2(-1000, initial_plane_pos.y), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		plane_tween.start()
	else:
		plane_tween.interpolate_property(plane_node, "transform/pos", initial_plane_pos, Vector2(1000, initial_plane_pos.y), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		plane_tween.start()
	pass

func switching_finished(_object, _key):
	plane_tween.interpolate_property(plane_node, "transform/pos", plane_node.position, initial_plane_pos, 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	plane_tween.start()
	pass

func _on_right_arrow_pressed():
	_on_arrow_pressed(direction.RIGHT)
	#switch_plane(false)

func _on_left_arrow_pressed():
	_on_arrow_pressed(direction.LEFT)
	#switch_plane(true)
	pass

func game_over_animation_finished():
	if $game_over/AnimatedSprite.name != "last":
		$game_over/AnimatedSprite.play("last")
	pass


func fill_values():
	var file = File.new()
	var current_data = global.saved_data

	if !file.file_exists(global.save_file_path):
		file.open(global.save_file_path, File.READ_WRITE)

		file.store_string(to_json(global.saved_data))
		current_data = parse_json(file.get_as_text())
	else:
		file.open(global.save_file_path, File.READ_WRITE)
		current_data = parse_json(file.get_as_text())
		if current_data == null:
			file.store_string(to_json(global.saved_data))
			current_data = global.saved_data

	music = false
	
	music = current_data["music"]
	print("Off" + str(music))
	global.saved_data["music"] = music
	
	if music:
		music_btn.set_normal_texture(load("res://Images/UI/Sound_OFF.png"))
	else:
		music_btn.set_normal_texture(load("res://Images/UI/Sound_ON.png"))

	score_lbl.text = "Score:" + str(current_data["score"])
	coins_lbl.text = "Coins:" +str(current_data["coins"])
	file.close()

	_on_music_button_up(false)
	pass

func _on_credits_button_up():
	get_tree().change_scene("res://Nodes/Info.tscn")
	pass

func load_score():
	var f = File.new()
	if f.file_exists(global.save_file_path):
		f.open(global.save_file_path,File.READ)
		var score = f.get_as_text()
		f.close()
		return int(score)
	pass


func _on_music_button_up(_toogle = true):
	var file = File.new()
	var off = false
	var current_data = null
	var toggle = _toogle
	file.open(global.save_file_path, File.READ_WRITE)
	
	current_data = parse_json(file.get_as_text())
	if current_data == null:
		return

	if toggle == true:
		current_data["music"] = !current_data["music"]
		global.saved_data["music"] = current_data["music"]
		file.store_string(to_json(current_data))
	off = current_data["music"]
	
	file.close()
	
	if !off:
		music_btn.set_normal_texture(load("res://Images/UI/Sound_OFF.png"))
		music = false
	else:
		music_btn.set_normal_texture(load("res://Images/UI/Sound_ON.png"))
		music = true
	pass


func hide_game_over():
	find_node("game_over").visible = false
	pass
