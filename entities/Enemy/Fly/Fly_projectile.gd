extends KinematicBody2D

export var speed = 500

var velocity = Vector2(speed, 0)

onready var player = get_tree().get_root().get_node("TestLab/Player")

func _physics_process(delta):
	var collision =  move_and_collide(velocity * delta)    	 # move
	
	if collision:         	# if collision detected #
		queue_free()      	# destroy itself        #

# destroy upon exiting screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# set direction
func point():
	look_at(player.global_position)
	velocity = velocity.rotated(rotation + rand_range(-0.1, 0.1))
