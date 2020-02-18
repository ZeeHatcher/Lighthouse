extends KinematicBody2D

signal stair_entered(player, direction)

export (int) var speed_move := 200

var velocity := Vector2()

onready var gun := $Gun
onready var sprite_character := $Character
onready var sprite_rifle := $Rifle

func _ready() -> void:
	var stairs := get_tree().get_nodes_in_group("stairs")
	
	for stair in stairs:
		connect("stair_entered", stair, "_on_Player_stair_entered")

func _physics_process(_delta: float) -> void:
	aim()
	handle_move_input()
	handle_shoot()
	velocity = move_and_slide(velocity)
	

func handle_move_input() -> void:
	velocity = Vector2()
	
	if (Input.is_action_pressed("move_right")):
		velocity.x += 1
		
	if (Input.is_action_pressed("move_left")):
		velocity.x -= 1
		
	if (velocity.x == 0):
		sprite_character.play("idle")
		sprite_rifle.frame = 0
		sprite_rifle.visible = false
		gun.visible = true
	else:
		if (velocity.x > 0):
			sprite_character.flip_h = false
			sprite_rifle.flip_h = false
			sprite_rifle.position.x = 5
			
		elif (velocity.x < 0):
			sprite_character.flip_h = true
			sprite_rifle.flip_h = true
			sprite_rifle.position.x = -6
		
		sprite_rifle.visible = true
		sprite_character.play("run")
		sprite_rifle.play("run")
		gun.visible = false
		
	if (Input.is_action_just_pressed("move_down")):
		emit_signal("stair_entered", self, -1)
	
	if (Input.is_action_just_pressed("move_up")):
		emit_signal("stair_entered", self, 1)
	
	velocity = velocity.normalized() * speed_move

func handle_shoot() -> void:
	if (Input.is_action_just_pressed("click")):
		gun.fire()

func aim() -> void:
	var position_mouse := get_global_mouse_position()
	
	gun.look_at(get_global_mouse_position())
	sprite_character.flip_h = true if (position_mouse.x < global_position.x) else false
	gun.sprite.flip_v = true if (position_mouse.x < gun.global_position.x) else false
		
