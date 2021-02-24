extends Control


var coinValue = 0

func _ready():
	$coins.text = "Coins:" + str(coinValue)
	EventBus.connect("got_coin", self, "increaseCoin")
	pass

func increaseCoin():
	coinValue = coinValue + 1
	$coins.text = "Coins:" + str(coinValue)
	pass
