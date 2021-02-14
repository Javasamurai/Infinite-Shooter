extends Node2D


var coins = 0

func _ready():
	pass

func _on_Player_hit(enemy, health):
	if !enemy:
		$Control/healthProgress.value = health
	else:
		$ScreenShake.shake(0.25, 250, 1.5)
	pass
