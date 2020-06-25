extends KinematicBody2D

signal stair_entered(player, direction)

const TARGET_FPS = 60
const ACCELERATION = 8
const MAX_SPEED = 64
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 4
const JUMP_FORCE = 140

var disable_input := false

var velocity := Vector2()

onready var gun := $Gun
onready var sprite_character := $Character
onready var sprite_rifle := $Rifle

func _ready() -> void:
	var stairs := get_tree().get_nodes_in_group("stairs")
	
	for stair in stairs:
		connect("stair_entered", stair, "_on_Player_stair_entered")

func _process(delta):
	$CanvasLayer/Control/vbox/Velocity.text = str(velocity.x)
	
func _physics_process(delta):
	aim()
	handle_shoot()
	## Start of movement ##
	var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if x_input != 0:
		velocity.x += x_input * ACCELERATION * delta * TARGET_FPS
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		
	# Gravity #
	velocity.y += GRAVITY * delta * TARGET_FPS
	
	# Jump, stairs and terraria-esque mid-air movement #
	if (Input.is_action_just_pressed("move_down")):
#		yield(get_tree().create_timer(1.0),"timeout")
		emit_signal("stair_entered", self, 1)
		
	if is_on_floor() && disable_input == false:
		if x_input == 0:
			velocity.x = lerp(velocity.x, 0, FRICTION * delta)
		if Input.is_action_just_pressed("move_up"):
			velocity.y = -JUMP_FORCE
	else:
		if Input.is_action_just_released("move_up") and velocity.y < -JUMP_FORCE/2:
			velocity.y = -JUMP_FORCE/2
		if x_input == 0:
			velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE * delta)
			
	velocity = move_and_slide(velocity, Vector2.UP)

	## End of movement ##

	handle_animation()
	

#func stairs_input():
#	# Stair Inputs #
#	var x_input = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
#	match x_input:
#		-1:
#			emit_signal("stair_entered", self, -1)
#		1:
#			emit_signal("stair_entered", self, 1)
	
func handle_shoot() -> void:
	if (Input.is_action_just_pressed("click")): # left click
		gun.fire()
	if (Input.is_action_just_pressed("reload")): # r 
		gun.reload()

func aim() -> void:
	var position_mouse := get_global_mouse_position()
	gun.look_at(position_mouse)
	sprite_character.flip_h = true if (position_mouse.x < global_position.x) else false
	gun.sprite.flip_v = true if (position_mouse.x < gun.global_position.x) else false

func handle_animation() -> void:
	# Animation 
	if (round(velocity.x) == 0):
		sprite_character.play("idle")
		sprite_rifle.frame = 0
		sprite_rifle.visible = false
		gun.visible = true
	else:
		if (velocity.x  > 0):
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
