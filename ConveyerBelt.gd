extends Area2D

export (int) var direction := 1

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.get_class() == 'KinematicBody2D':
			body.velocity.x += 5000 * direction
