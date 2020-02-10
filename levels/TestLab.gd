extends Node2D

var title = "Alpha 0.1"
var enemy_text = ""
func _ready():
	pass

func _process(_delta):
	var enemy = get_tree().get_nodes_in_group("enemies").size();
	if  enemy != null:
		enemy_text = enemy
		
	OS.set_window_title(title + " | fps: " + str(Engine.get_frames_per_second()) + " | Mob count: " + str(enemy_text))
