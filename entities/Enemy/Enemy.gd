extends KinematicBody2D

export (int) var speed := 100

var velocity := Vector2(speed, 0)

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
func face(direction: int) -> void:
	if (direction):
		velocity *= -1

