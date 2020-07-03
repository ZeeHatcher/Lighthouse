extends Node2D

onready var scene_tree := get_tree()
onready var root := scene_tree.get_root()
onready var level := root.get_node("TestLab")
onready var viewport := level.get_viewport()
onready var lighthouse := level.get_node("Lighthouse")
onready var player := level.get_node("Player")


export (String) var title = "Alpha"
var enemy_text: int;

func _process(_delta):
	var enemy = get_tree().get_nodes_in_group("enemies").size();
	enemy_text = enemy if enemy != null else null
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	OS.set_window_title("{a} | fps: {b} | Mob count: {c}".format(
		{a = title,
		 b = Engine.get_frames_per_second(),
		 c = enemy_text})
		)
	
		# if its a single value you can do this instead
		#("%d is how many times you died") % value
