extends Particles2D

func _on_Area2D_area_entered(area):
	var area_name = area.get_node("..").name
	
	var isEnemy_bullet = area_name.find("enemy_bullet") != -1
	if isEnemy_bullet:
		area.get_node("..").queue_free()
	pass
