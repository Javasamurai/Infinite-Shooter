extends Node2D

export var spawnTimeWave = 15
export var spawnTimeEnemies = 1

func _ready():
	$SpawnTimer.wait_time = spawnTimeEnemies
	$SpawnTimerEnemies.wait_time = spawnTimeEnemies
	$SpawnTimer.connect("timeout", self, "spawnWave")
	$SpawnTimer.connect("timeout", self, "spawnEnemies")
	pass

func spawnWave():
	pass

func spawnEnemies():
	pass
