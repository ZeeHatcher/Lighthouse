extends Camera2D
	
func _process(delta: float):
	position.x = get_local_mouse_position().x
