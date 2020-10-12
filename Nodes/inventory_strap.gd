extends TextureRect

export(NodePath) var plane_parent_path

var plane_parent
var left_limit = 90
var right_limit = 800


func _ready():
	plane_parent = get_node(plane_parent_path)
	set_process_input(true)
	pass

func _input(event):
	if event is InputEventScreenDrag:
	
		if plane_parent.rect_position.x < left_limit && plane_parent.rect_position.x > -right_limit:
			plane_parent.rect_position.x = plane_parent.rect_position.x + event.relative.x 
		elif plane_parent.rect_position.x >= left_limit &&  event.relative.x < 0:
			plane_parent.rect_position.x = plane_parent.rect_position.x + event.relative.x 
		elif plane_parent.rect_position.x <= -right_limit &&  event.relative.x > 0:
			plane_parent.rect_position.x = plane_parent.rect_position.x + event.relative.x 
	pass
