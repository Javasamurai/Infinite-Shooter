extends Node2D

signal got_coin

func on_got_coin(area):
	if area.name == "bullet_area":
		$audio.play()
		connect("got_coin", get_node("../"), "got_coin")
	pass


func _on_audio_finished():
	queue_free()
	pass
