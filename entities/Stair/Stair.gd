extends Area2D

export (int) var level := 0

onready var scene_tree := get_tree()

func _ready() -> void:
	add_to_group("stairs")
	
func warp(entity: KinematicBody2D, direction: int) -> void:
	var stairs := get_tree().get_nodes_in_group("stairs")
	var level_next := level + direction
	
	if (level_next < 0 || level_next >= stairs.size()):
		return
	
	for stair in stairs:
		if (stair.level == level_next):
			entity.global_position = stair.global_position
			break

func _on_Player_stair_entered(player: KinematicBody2D, direction: int) -> void:
	if (overlaps_body(player)):
		warp(player, direction)
