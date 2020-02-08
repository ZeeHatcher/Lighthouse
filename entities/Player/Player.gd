extends KinematicBody2D

signal stair_entered(player, direction)

export (int) var speed_move := 200

var velocity := Vector2()

onready var gun := $Gun

func _ready() -> void:
	var stairs := get_tree().get_nodes_in_group("stairs")
	
	for stair in stairs:
		connect("stair_entered", stair, "_on_Player_stair_entered")

func _physics_process(_delta: float) -> void:
	handle_move_input()
	aim()
	handle_shoot()
	velocity = move_and_slide(velocity)

func handle_move_input() -> void:
	velocity = Vector2()
	
	if (Input.is_action_pressed("move_right")):
		velocity.x += 1
	
	if (Input.is_action_pressed("move_left")):
		velocity.x -= 1
		
	if (Input.is_action_just_pressed("move_down")):
		emit_signal("stair_entered", self, -1)
	
	if (Input.is_action_just_pressed("move_up")):
		emit_signal("stair_entered", self, 1)
	
	velocity = velocity.normalized() * speed_move

func handle_shoot() -> void:
	if (Input.is_action_just_pressed("click")):
		gun.fire()

func aim() -> void:
	gun.look_at(get_global_mouse_position())
