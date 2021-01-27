extends Control

func _ready():
	pass # Replace with function body.

func update_health(health):
	print(health)
	$healthProgress.value = health
