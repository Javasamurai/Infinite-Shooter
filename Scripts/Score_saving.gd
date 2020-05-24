extends Node

var score_path = "user://score.txt"
func _ready():
	$".".text = str(load_score())
	pass
	
func load_score():
	var f = File.new()
	if f.file_exists(score_path):
		f.open(score_path,File.READ)
		var score = f.get_as_text()
		#highscore = int(score)
		f.close()
		return int(score)
	pass

func save_score(score):
	var f = File.new()
	f.open(score_path)
	f.store_string(score)
	f.close()
	pass
