extends Camera2D
	
func _process(delta: float):
	global_position.x = get_global_mouse_position().x
