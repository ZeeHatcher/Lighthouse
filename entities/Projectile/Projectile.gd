extends KinematicBody2D

export (int) var speed := 30

var velocity := Vector2(speed, 0)

func _ready():
	add_to_group("projectiles")

func _physics_process(delta: float) -> void:
	
	var _collision = move_and_collide(velocity * delta)
	
func point_to(target: Vector2) -> void:
	look_at(target)
	velocity = velocity.rotated(rotation)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

