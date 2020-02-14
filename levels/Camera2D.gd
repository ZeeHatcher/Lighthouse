extends Camera2D
	
func _process(delta: float):
	position = get_local_mouse_position()
