extends Node2D

var time := 0.0

func _ready():
	pass
	
func _process(delta):
	scale.x = sin(time)
	
	time += delta
