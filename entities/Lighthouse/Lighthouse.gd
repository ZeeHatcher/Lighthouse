extends Area2D

export var health_max := 100

onready var health_current := health_max

func _on_Lighthouse_body_entered(body: Node):
	if (body.is_in_group("projectile_enemy")):
		health_current -= 1
#		print(health_current)
		body.queue_free()
		
