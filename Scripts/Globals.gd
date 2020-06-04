extends Node

var selected_plane = 1
var over = false
var score = 0
var save_file_path = "user://score.save"

var saved_data = {
	"score": 0,
	"music": true,
	"coins": 0
}

func _ready():
	var file = File.new()
	var current_data = null

	current_data = parse_json(file.get_as_text())
	if current_data != null:
		saved_data["coins"] = current_data["coins"]
	pass
