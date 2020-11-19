extends Node2D

signal got_coin

var global
var move = false
var got_coin = false

func _ready():
	global = get_node("/root/Globals")
	set_process(true)
	pass
	
func _process(delta):
	if move:
		position.y = ( position.y + (100 *  delta) )
	pass

func on_got_coin(area):
	if area.name == "bullet_area":
		if !got_coin:
			got_coin = true
			$audio.play()
			global.saved_data["coins"] = global.saved_data["coins"] + 1
			connect("got_coin", get_node("../"), "got_coin")
			queue_free()
	pass

func _on_audio_finished():
	# queue_free()
	pass
