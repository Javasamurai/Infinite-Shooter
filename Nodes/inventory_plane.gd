extends TextureRect

var selected = false

func _process(delta):
	if self.rect_global_position.x > 0 && self.rect_global_position.x < 100:
		var diff = clamp( abs ( (20 - self.rect_global_position.x) / 50), 0.75, 1)
		self.rect_scale = Vector2(diff, diff)
	elif self.rect_global_position.x > 100:
		var diff = clamp(  (150 - self.rect_global_position.x) / 50, 0.75, 1)
		self.rect_scale = Vector2(diff, diff)
	pass
