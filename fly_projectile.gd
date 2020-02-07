extends KinematicBody2D

onready var player = get_tree().get_root().get_node('TestLab/Player')

var speed = 500
var velocity = Vector2(speed, 0)

func _ready():
	pass
	
func _physics_process(delta):
	if move_and_collide(velocity * delta):
		queue_free()
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func point():
	look_at(player.global_position)
	velocity = velocity.rotated(rotation + rand_range(-0.1, 0.1))
