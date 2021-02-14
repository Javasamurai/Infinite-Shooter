extends Node

var selected_plane = 1
var over = false
var score = 0
var current_wave = 1
var isDroneInventory = false
var save_file_path = "user://score.save"

var screen_width = 0
var screen_height = 0

var saved_data = {
	"score": 0,
	"music": true,
	"coins": 0
}

var purchased_planes = []

func _ready():
	#var _file = File.new()
	#var current_data = null

	#file.open(save_file_path, File.READ)
	#current_data = parse_json(file.get_as_text())
	#if current_data != null:
	#	saved_data["coins"] = current_data["coins"]
	screen_width = OS.get_window_safe_area().size.x
	screen_height = OS.get_window_safe_area().size.y
	pass
