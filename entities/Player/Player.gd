class_name Player
extends KinematicBody2D

signal stair_entered(player, direction)

enum {IDLE, WALKING, SHOOTING}

const TARGET_FPS = 60
const ACCELERATION = 8
const MAX_SPEED = 64
const AIR_RESISTANCE = 1
const GRAVITY = 4
const JUMP_FORCE = 140

var FRICTION = 10
var velocity := Vector2()
var x_input: int
var state := IDLE

onready var gun := $Gun
onready var sprite_character := $Animation/Gunner
onready var sprite_rifle := $Animation/Rifle
onready var ap := $Animation/AnimationPlayer
onready var tween := $Tween


func _ready() -> void:
	var stairs := get_tree().get_nodes_in_group("stairs")
	
	for stair in stairs:
		connect("stair_entered", stair, "_on_Player_stair_entered")


func _physics_process(delta):
	match state:
		IDLE:
			ap.play("Stand")
			sprite_rifle.visible = false
			gun.visible = true
		WALKING:
			if x_input != 0:
				velocity.x += x_input * ACCELERATION * delta * TARGET_FPS
				velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
				
				ap.play("Walk")
				sprite_character.flip_h = x_input < 0
				sprite_rifle.flip_h = x_input < 0
				sprite_rifle.position.x = -6 if x_input < 0 else 5
				sprite_rifle.visible = true
				gun.visible = false
			else:
				ap.play("Stand")
				sprite_rifle.visible = false
				gun.visible = true
			# Gravity #
			
			# Jump, stairs and terraria-esque mid-air movement #
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
		SHOOTING:
			aim()
			handle_shoot()
	## Start of movement ##

	
	velocity.y += GRAVITY * delta * TARGET_FPS
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func _input(event):
	x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if (Input.is_action_just_pressed("move_down")):
		emit_signal("stair_entered", self, 1)
	if (Input.is_action_just_pressed("E")):
		tween.interpolate_property(self,"position",get_global_position(), get_global_mouse_position(), 1.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()


func handle_shoot() -> void:
	if (Input.is_action_just_pressed("leftclick")): # left click
		gun.fire()
	if (Input.is_action_just_pressed("reload")): # r 
		gun.reload()

func aim() -> void:
	var position_mouse := get_global_mouse_position()
	sprite_character.flip_h = true if (position_mouse.x < global_position.x) else false
	gun.look_at(position_mouse)
