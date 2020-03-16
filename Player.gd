extends KinematicBody2D

export (int) var speed := 50

var velocity := Vector2()
var disable_input := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if !disable_input:
		get_input()


func _physics_process(delta):
	apply_gravity()
	apply_friction()
	apply_slope()
	
	
	move_and_slide(velocity*delta, Vector2.UP)
	


func get_input():
	if Input.is_action_pressed("left"):
		velocity.x -= speed
	if Input.is_action_pressed("right"):
		velocity.x += speed
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -5000
		
	if Input.is_mouse_button_pressed(1):
		position = get_global_mouse_position()
		velocity = Vector2()
		
func apply_friction():
	if is_on_floor():
		velocity.x *= 0.97

func apply_gravity():
	velocity.y += 100

func apply_slope():
	if is_on_wall():
		disable_input = true
		if abs(velocity.x) >= speed:
			velocity.y = -velocity.x
		velocity.x = 0
	else:
		disable_input = false
		
func propel(body_entered, detecting_area):
	var direction = detecting_area.position - position
	print(-direction*20)
	velocity = -direction*2000
