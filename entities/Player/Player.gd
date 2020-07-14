extends KinematicBody2D

signal stair_entered(player, direction)

const TARGET_FPS = 60
const ACCELERATION = 8
const MAX_SPEED = 64
var FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 4
const JUMP_FORCE = 140

var velocity := Vector2()

onready var gun := $Gun
onready var sprite_character := $Gunner
onready var sprite_rifle := $Rifle


func _ready() -> void:
	add_to_group("player")
	
	var stairs := get_tree().get_nodes_in_group("stairs")
	
	for stair in stairs:
		connect("stair_entered", stair, "_on_Player_stair_entered")

func _process(_delta):
	# Assigns a value for velocity to the text box top left
	$CanvasLayer/Control/vbox/Velocity.text = "Velocity X:" + str(velocity.x)

func _physics_process(delta):
	aim()
	handle_shoot()
	## Start of movement ##
	var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if x_input != 0:
		velocity.x += x_input * ACCELERATION * delta * TARGET_FPS
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		
		$AnimationPlayer.play("Walk")
		sprite_character.flip_h = x_input < 0
		sprite_rifle.flip_h = x_input < 0
		sprite_rifle.position.x = -6 if x_input < 0 else 5
		sprite_rifle.visible = true
		gun.visible = false
	else:
		$AnimationPlayer.play("Stand")
		sprite_rifle.visible = false
		gun.visible = true
	# Gravity #
	velocity.y += GRAVITY * delta * TARGET_FPS
	
	# Jump, stairs and terraria-esque mid-air movement #
	if (Input.is_action_just_pressed("move_down")):
#		yield(get_tree().create_timer(1.0),"timeout")
		emit_signal("stair_entered", self, 1)
		
	if is_on_floor():
		if x_input == 0:
			velocity.x = lerp(velocity.x, 0, FRICTION * delta)
		if Input.is_action_just_pressed("move_up"):
			velocity.y = -JUMP_FORCE
	else:
		if Input.is_action_just_released("move_up") and velocity.y < float(-JUMP_FORCE)/2:
			velocity.y = float(-JUMP_FORCE)/2
		if x_input == 0:
			velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE * delta)
	
	# For the player not get stuck on the ceiling #
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (Input.is_action_just_pressed("E")):
		position = lerp(get_global_position(), get_global_mouse_position(), 0.5)

	## End of movement ##
	
func handle_shoot() -> void:
	if (Input.is_action_just_pressed("click")): # left click
		gun.charge()
		yield(get_tree().create_timer(1.0),"timeout")
		gun.fire()
		velocity = Vector2.ZERO
	if (Input.is_action_just_pressed("reload")): # r 
		gun.reload()

func aim() -> void:
	var position_mouse := get_global_mouse_position()
	sprite_character.flip_h = true if (position_mouse.x < global_position.x) else false
	gun.look_at(position_mouse)

