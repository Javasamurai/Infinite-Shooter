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
var hamburger_visible = false

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
	$anim.play("cloud_movement")
	#$anim.play("fade")

	var rot_tween = earth_node.get_node("Tween")
	rot_tween.interpolate_property(earth_node, "rotation_degrees", 0, 36000, 1500,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	rot_tween.start()
	
	if global.selected_plane == 1:
		left_arrow.modulate = Color(0,0.0, 0.75)
		left_arrow.disabled = true
	if global.selected_plane == 3:
		right_arrow.modulate = Color.white

	#if global.over:
	#	if !music:
	#		get_node("/root/Control/AudioManager/death").play()
	#	global.over = false
	#	$game_over.visible=true
	#
	#	$Timer.start(3)
	
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_LEFT:
			_on_left_arrow_pressed()
		elif event.pressed and event.scancode == KEY_RIGHT:
			_on_right_arrow_pressed()
		elif event.pressed and event.scancode == KEY_P:
			switch_scene()


func game_over():
	$game_over/AnimatedSprite.play()
	pass
	
func toInventory(drone = false):
	global.isDroneInventory = drone
	playButtonAudio()
	get_tree().change_scene("res://Nodes/Inventory.tscn")
	pass

func _process(delta):
	time_spent+= delta
	if global.selected_plane == 3:
		if time_spent > 1.25 and flames_lvl_3_left.visible == false:
			flames_lvl_3_left.visible = true
			flames_lvl_3_right.visible = true
			plane_node.set_texture(load("res://Images/UI_Planes/UI_Level_" + str(global.selected_plane) + "_Plane_05.png"))

func _on_arrow_pressed(_direction):
	if !music:
		button_click.play()
	
	if _direction == direction.LEFT:
		right_arrow.modulate = Color.white
		right_arrow.disabled = false
		
		if global.selected_plane > 1:
			left_arrow.modulate = Color.white
			global.selected_plane = global.selected_plane - 1
		else:
			left_arrow.disabled = true

	if _direction == direction.RIGHT:
		left_arrow.modulate = Color.white
		left_arrow.disabled = false
		if global.selected_plane < 8:
			right_arrow.disabled = false
			right_arrow.modulate = Color.white
			global.selected_plane = global.selected_plane + 1
		else:
			right_arrow.disabled = true
			right_arrow.modulate = Color(0,0.0, 0.75)
		pass
	var tex = null

	if global.selected_plane == 1:
		left_arrow.modulate = Color(0,0.0, 0.75)
		left_arrow.disabled = true
	if global.selected_plane == 8:
		right_arrow.modulate = Color(0,0.0, 0.75)
		right_arrow.disabled = true

		
	if global.selected_plane == 3:
		time_spent = 0
		
		var texture = {}
		var anim_tex = AnimatedTexture.new()
		anim_tex.set_frames(4)
		anim_tex.set_fps(3)

		for i in range(6):
			texture[i+1] = load("res://Images/UI_Planes/UI_Level_" + str(global.selected_plane) + "_Plane_0" + str(i + 1) + ".png")
			anim_tex.set_frame_texture(i, texture[i+1])
		plane_node.set_texture(anim_tex)

		flames_lvl_3_left.visible = false
		flames_lvl_3_right.visible = false
	else:
		tex = load("res://Images/UI_Planes/UI_Level_" + str(global.selected_plane) + "_Plane.png")
		plane_node.set_texture(tex)
		flames_lvl_3_left.visible = false
		flames_lvl_3_right.visible = false
	pass

func switch_scene():
	get_tree().change_scene("res://GamePlayTest.tscn")
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
	if !right_arrow.disabled:
		$anim.play("right")
	#_on_arrow_pressed(direction.RIGHT)
	#switch_plane(false)

func _on_left_arrow_pressed():

	if !left_arrow.disabled:
		$anim.play("left")
	#_on_arrow_pressed(direction.LEFT)
	#switch_plane(true)
	pass


func fill_values():
	var file = File.new()
	var current_data = global.saved_data

	if !file.file_exists(global.save_file_path):
		file.open(global.save_file_path, File.WRITE_READ)
		file.store_string(to_json(current_data))
		current_data = parse_json(file.get_as_text())
	else:
		file.open(global.save_file_path, File.WRITE_READ)
		current_data = parse_json(file.get_as_text())
		if current_data == null:
			file.store_string(to_json(global.saved_data))
			current_data = global.saved_data

	music = false
	
	if current_data == null:
		return
	music = current_data["music"]
	global.saved_data["music"] = music
	
	if music:
		music_btn.set_normal_texture(load("res://Images/UI/Sound_OFF_01.png"))
	else:
		music_btn.set_normal_texture(load("res://Images/UI/Sound_ON.png"))

	score_lbl.text = "Score:" + str(current_data["score"])
	coins_lbl.text = "Coins:" +str(current_data["coins"])
	file.close()

	_on_music_button_up(false)
	pass

func _on_credits_button_up():
	get_tree().change_scene("res://Nodes/Credits.tscn")
	pass

func _on_enemies_button_up():
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

	file.open(global.save_file_path, File.READ)

	current_data = parse_json(file.get_as_text())
	if current_data == null:
		return

	if toggle:
		current_data["music"] = !current_data["music"]
		global.saved_data["music"] = current_data["music"]
		file = File.new()
		file.open(global.save_file_path, File.WRITE)
		file.store_string(to_json(current_data))
	off = !current_data["music"]

	if off:
		$AudioManager/bgm.stop()
	else:
		$AudioManager/bgm.play()
	
	file.close()
	
	if off:
		music_btn.set_normal_texture(load("res://Images/UI/Sound_OFF_01.png"))
		music = false
	else:
		music_btn.set_normal_texture(load("res://Images/UI/Sound_ON.png"))
		music = true
	pass

func hide_game_over():
	find_node("game_over").visible = false
	pass
	
func spawnMeteor():
	pass

func _on_anim_animation_finished(anim_name):
	$anim.play("cloud_movement")
	$anim.play("fade")
	if (anim_name == "left"):
		_on_arrow_pressed(direction.LEFT)
	elif (anim_name == "right"):
		_on_arrow_pressed(direction.RIGHT)
	pass


func _on_hamburger_pressed():
	hamburger_visible = !hamburger_visible
	button_click.play()

	$Container/HBoxContainer/hamburger/Control.visible = hamburger_visible
	#if !hamburger_visible:
	#	$Container/hamburger/animation_player.play_backwards("slide_down")
	#else:
	#	$Container/hamburger/animation_player.play("slide_down")
	#$Container/hamburger/Control.visible = hamburger_visible
	pass


func playButtonAudio():
	$AudioManager/ButtonClick.play()
	pass
