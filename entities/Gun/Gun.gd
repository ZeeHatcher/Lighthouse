extends Node2D

onready var muzzle := $Muzzle

#func fire() -> void:
#	var bullet := SCENES.projectile_bullet.instance()
#	ENTITIES.level.add_child(bullet)
#
#	bullet.global_position = muzzle.global_position
#	bullet.point_to(get_global_mouse_position())


onready var scene_lightning = preload("res://assets/Lightning.tscn")
func fire() -> void:
	var lightning : Line2D = scene_lightning.instance()
	ENTITIES.level.add_child(lightning)

	lightning.global_position = muzzle.global_position
	lightning.set_point_position(1, get_global_mouse_position() - muzzle.global_position)
	lightning.area.position = get_global_mouse_position() - muzzle.global_position

