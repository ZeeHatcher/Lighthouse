extends Projectile

onready var scene_tree := get_tree()
onready var root := scene_tree.get_root()
onready var level := root.get_node("TestLab")

func _maneuver(delta: float) -> void:
	pass

func _on_collide(collider: Object) -> void:
#	queue_free()
	pass
