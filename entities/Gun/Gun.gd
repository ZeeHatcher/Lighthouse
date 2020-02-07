extends Node2D

onready var level := get_tree().get_root().get_node("TestLab")
onready var muzzle := $Muzzle
onready var scene_projectile := preload("res://entities/Projectile/Projectile.tscn")

func fire() -> void:
	var projectile := scene_projectile.instance()
	level.add_child(projectile)
	
	projectile.global_position = muzzle.global_position
	projectile.point_to(get_global_mouse_position())
