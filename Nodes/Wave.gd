extends Node2D


signal nextWave

func checkWave():
	if get_child_count() <= 0:
		WaveDone()
	pass

func WaveDone():
	emit_signal("nextWave")
	queue_free()
	pass
