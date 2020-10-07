extends ParallaxLayer

export var speed = 400
var time_spent = 0
var init_speed = 300
func _ready():
	set_process(true)
	pass
func _process(delta):
	time_spent+=delta
	motion_offset.y+=(speed * delta)
	
	if (time_spent > 10):
		speed+=1
		time_spent = 0
	pass

func _on_HSlider_value_changed(value):
	speed = init_speed * (value / 100)
	pass
