extends Node2D

onready var level := get_tree().get_root().get_node("TestLab")
onready var muzzle := $Muzzle
onready var scene_projectile := preload("res://entities/Projectile/Projectile.tscn")

func fire() -> void:
	var projectile := scene_projectile.instance()
	level.add_child(projectile)
	
	projectile.global_position = muzzle.global_position
	projectile.point_to(get_global_mouse_position())

#
#onready var scene_lightning = preload("res://assets/Lightning.tscn")
#func fire() -> void:
#	var lightning : Line2D = scene_lightning.instance()
#	level.add_child(lightning)
#
#	lightning.global_position = muzzle.global_position
#	lightning.set_point_position(1, get_global_mouse_position() - muzzle.global_position)
#	lightning.area.position = get_global_mouse_position() - muzzle.global_position

