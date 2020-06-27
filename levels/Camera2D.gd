extends Camera2D

export (int) var min_camera_limit = 200

func _process(_delta: float):
	if abs(get_local_mouse_position().x) > min_camera_limit:
		if get_local_mouse_position().x > 0:
			position.x = get_local_mouse_position().x - min_camera_limit
		else:
			position.x = get_local_mouse_position().x + min_camera_limit
