extends Node2D

onready var scene_tree := get_tree()
onready var root := scene_tree.get_root()
onready var level := root.get_node("TestLab")
onready var viewport := level.get_viewport()

onready var lighthouse := level.get_node("Lighthouse")
onready var player := level.get_node("Player")

var title = "Alpha 0.1"
var enemy_text = ""
func _ready():
	pass

func _process(_delta):
	var enemy = get_tree().get_nodes_in_group("enemies").size();
	if  enemy != null:
		enemy_text = enemy
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	OS.set_window_title(title + " | fps: " + str(Engine.get_frames_per_second()) + " | Mob count: " + str(enemy_text))
