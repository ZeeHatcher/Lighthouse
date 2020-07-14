extends Node2D

onready var scene_tree := get_tree()
onready var root := scene_tree.get_root()
onready var level := root.get_node("TestLab")
onready var viewport := level.get_viewport()
onready var lighthouse := level.get_node("Lighthouse")
onready var player := level.get_node("Player")


export (String) var title = "Alpha"
var enemy
var enemy_text

func _process(_delta):
	enemy = get_tree().get_nodes_in_group("enemies").size();
	enemy_text = enemy if enemy != null else null
	OS.set_window_title("{a} | fps: {b} | Mob count: {c}".format(
		{a = title,
		 b = Engine.get_frames_per_second(),
		 c = enemy_text})
		)
	
		# if its a single value you can do this instead
		#("%d is how many times you died") % value
