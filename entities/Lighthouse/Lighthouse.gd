extends Area2D


func _ready():
	pass


func _on_Lighthouse_body_entered(body):
	if body.is_in_group("projectiles"):
		body.visible = false
		body.queue_free()
