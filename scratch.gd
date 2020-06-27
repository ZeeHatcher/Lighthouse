tool
extends Sprite


export var speed = 1 setget set_speed


# Update speed and reset the rotation.
func set_speed(new_speed):
	speed = new_speed
	rotation_degrees = 0


func _process(delta):
	rotation_degrees += 180 * delta * speed
