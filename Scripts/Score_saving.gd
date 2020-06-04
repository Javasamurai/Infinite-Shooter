extends Node

var score_path = "user://score.txt"
var global

func _ready():
	global = get_node("/root/Globals")

#	$".".text = "Max Score:" + str(load_score())
	pass

func load_coins():
	
	pass

func load_score():
	var f = File.new()
	if f.file_exists(global.save_file_path):
		f.open(global.save_file_path,File.READ)
		var score = f.get_as_text()
		print(score)
		#highscore = int(score)
		f.close()
		return int(score)
	pass
