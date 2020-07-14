extends Enemy

onready var timer_move := $RandomMoveTimer

export var steer_force = 10

var acceleration = Vector2()
var target = Vector2()

func _on_spawn() -> void:
	speed = 50
	rotation += rand_range(-10, 10)

func _move(delta: float) -> void:
	pass

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	target = level.player.position
	
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	move_and_collide(velocity * delta)
