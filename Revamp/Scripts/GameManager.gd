extends Node2D

var coins = 0
var coin_node

func _ready():
	coin_node = load("res://Revamp/Nodes/coin.tscn")
	EventBus.connect("spawnCoinAt", self, "spawnCoin")
	pass

func spawnCoin(position, delay):
	yield(get_tree().create_timer(delay),"timeout")
	var coin_clone = coin_node.instance()
	coin_clone.position = position
	coin_clone.active = true
	add_child(coin_clone)
	pass

func _on_Player_hit(enemy, health):
	if !enemy:
		$Control/healthProgress.value = health
	else:
		$ScreenShake.shake(0.25, 250, 1.5)
	pass
