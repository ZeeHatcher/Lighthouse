extends Projectile

#onready var scene_tree := get_tree()
#onready var root := scene_tree.get_root()
#onready var level := root.get_node("TestLab")

func _maneuver(_delta: float) -> void:
	pass

func _on_collide(_collider: Object) -> void:
	print("colliding")
	pass
