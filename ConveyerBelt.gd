extends Area2D

export (int) var direction := 1
export (int) var strength := 5000

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.get_class() == 'KinematicBody2D':
			body.velocity.x += strength * direction
			if direction < 0:
				body.max_speed_left -= strength
				body.max_speed_right -= strength * delta
			elif direction > 0:
				body.max_speed_right += strength
				body.max_speed_left += strength * delta
