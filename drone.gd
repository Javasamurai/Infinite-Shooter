extends AnimatedSprite


var activated = false
var target = null
var tween
func _ready():
	tween = get_node("../../Tween")
	$Area2D.connect("area_entered", self, "drone_hit")
	pass

func _process(_delta):
	if is_instance_valid(target) && activated:
		chaseTarget()
	pass

func chaseTarget():
	if tween != null:
		if position != target.position && position.y > target.position.y:
			var size = 40 / 2
			tween.interpolate_property(self, "position", position, Vector2(target.position.x ,target.position.y - size), 0.25,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
	pass

func drone_hit(area):
	if area.name == "enemy_area" && activated:
		area.get_node("../").hit(true)
		queue_free()
	pass
