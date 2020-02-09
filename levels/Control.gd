extends Control

var not_paused = true

func _ready():
	pass

func _process(delta):
	# pause is spacebar
	if Input.is_action_just_pressed("pause"):
		if not_paused:
			get_tree().paused = true
			not_paused = false
			visible = true
		else:
			get_tree().paused = false
			not_paused = true
			visible = false
