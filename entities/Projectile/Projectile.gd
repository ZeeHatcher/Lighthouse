extends KinematicBody2D

export (int) var speed := 3000

var velocity := Vector2(speed, 0)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if (collision):
		if (collision.collider.is_in_group("enemies")):
			collision.collider.queue_free()
		else:
			queue_free()

func point_to(target: Vector2) -> void:
	look_at(target)
	velocity = velocity.rotated(rotation)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
