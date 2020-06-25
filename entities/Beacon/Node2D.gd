extends Node2D

var time := 0.0

func _ready():
	pass
	
func _physics_process(delta):
	scale.x = sin(time)
	
	time += delta
