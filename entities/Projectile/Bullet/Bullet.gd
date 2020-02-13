extends Projectile

func _maneuver(delta: float) -> void:
	pass

func _on_collide(collider: Object) -> void:
	if (collider.is_in_group("enemies")):
		collider.queue_free()
	else:
		queue_free()
