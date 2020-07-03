class_name Enemy
extends KinematicBody2D

enum Side { LEFT, RIGHT }

onready var scene_tree := get_tree()
onready var root := scene_tree.get_root()

onready var level := root.get_node("TestLab")

export (int) var speed = 0

var side : int = Side.LEFT setget set_side

onready var velocity := Vector2(speed, 0)

onready var hit_box := $CollisionShape2D

onready var sprite := $Sprite

onready var occluder := $LightOccluder2D

func _ready() -> void:
	add_to_group("enemies")
	_on_spawn()

func _physics_process(delta: float) -> void:
	_move(delta)
	_attack(delta)
	
	var _collision = move_and_collide(velocity * delta, false)

func set_side(value: int) -> void:
	if (value in [Side.LEFT, Side.RIGHT]):
		side = value
		_flip()

# warning-ignore:unused_argument
func _attack(delta: float) -> void:
	pass
	
func _flip() -> void:
	pass

func _on_spawn() -> void:
	pass

# warning-ignore:unused_argument
func _move(delta: float) -> void:
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
