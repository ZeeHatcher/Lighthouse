extends Node2D

onready var scene_tree := get_tree()
onready var root := scene_tree.get_root()
onready var level := root.get_node("TestLab")
onready var viewport := level.get_viewport()
onready var paths := [$LeftPath, $RightPath]
onready var timer := $Timer
#onready var scene_enemy := SCENES.enemy_fly
onready var scene_enemy := SCENES.enemy_swarm

func _ready():
	pass

func _on_Timer_timeout():
	var side := randi() % 2
	var spawn_point : PathFollow2D = paths[side].get_node("PathFollow2D")
	
	spawn_point.offset = randi() % int(viewport.size.y)
	
	var enemy = scene_enemy.instance()
	enemy.global_position = spawn_point.global_position
	
	level.add_child(enemy)
	enemy.set_side(side)
	
