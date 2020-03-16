extends Area2D

onready var player = get_node("../Player")

func _ready():
	add_to_group("Explosives")
	connect("body_entered", player, "propel", [self])

func _process(delta):
	pass
	
