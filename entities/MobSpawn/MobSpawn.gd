extends Node2D

onready var level := get_tree().get_root().get_node("TestLab")
onready var viewport := level.get_viewport()
onready var paths := [$LeftPath, $RightPath]
onready var timer := $Timer
onready var scene_enemy := preload("res://entities/Enemy/Enemy.tscn")

func _on_Timer_timeout():
	var side := randi() % 2
	var spawn_point : PathFollow2D = paths[side].get_node("PathFollow2D")
	
	spawn_point.offset = randi() % int(viewport.size.y)
	
	var enemy = scene_enemy.instance()
	level.add_child(enemy)
	enemy.global_position = spawn_point.global_position
	enemy.face(side)
