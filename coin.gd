extends Node2D

signal got_coin

var global

func _ready():
	global = get_node("/root/Globals")
	pass
func on_got_coin(area):
	if area.name == "bullet_area":
		$audio.play()
		global.saved_data["coins"] = global.saved_data["coins"] + 1
		connect("got_coin", get_node("../"), "got_coin")
	pass


func _on_audio_finished():
	queue_free()
	pass
