extends KinematicBody2D

export (int) var speed := 5000
export (int) var seconds := 1

var is_collide = false
var time_to_live := seconds * 60
var velocity := Vector2(speed, 0)

func _physics_process(delta: float) -> void:
	is_collide = move_and_collide(velocity * delta)
	time_to_live -= 1
	
	if (is_collide || time_to_live <= 0):
		queue_free()

func point_to(target: Vector2) -> void:
	look_at(target)
	velocity = velocity.rotated(rotation)
