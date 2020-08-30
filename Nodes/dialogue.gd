extends Label


var dialogue_text
var current_index = 0

func _ready():
	dialogue_text = text
	text = ""
	pass


func _on_dialogue_timer_timeout():
	
	current_index = current_index + 1 
	text = dialogue_text.substr(0, current_index)

	pass
