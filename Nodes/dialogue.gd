extends Label


var current_index = 0
export(String) var dialogue_text
func _ready():
	text = ""
	pass


func _on_dialogue_timer_timeout():
	current_index = current_index + 1 
	text = dialogue_text.substr(0, current_index)
	pass
