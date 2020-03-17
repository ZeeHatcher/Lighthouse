extends KinematicBody2D

export (int) var max_speed_left := -5000
export (int) var max_speed_right := 5000

var velocity := Vector2()
var disable_input := false
var floor_too_long := true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if disable_input == false:
		get_input()


func _physics_process(delta):
	apply_gravity()
	apply_friction()
	apply_slope()
	is_on_floor_for_too_long()
	handle_max_speed_direction()
	
	move_and_slide(velocity*delta, Vector2.UP)


func get_input():
	if Input.is_action_pressed("left"):
		velocity.x = lerp(velocity.x, max_speed_left, 0.5)
	if Input.is_action_pressed("right"):
		velocity.x = lerp(velocity.x, max_speed_right, 0.5)
	print($RayCast2D.get_collider())
	if $RayCast2D.get_collider() and Input.is_action_just_pressed("jump"):
		velocity.y = -15000
		if velocity.x < 0:
			max_speed_left -= 2500
		elif velocity.x > 0:
			max_speed_right += 2500
		
	if Input.is_mouse_button_pressed(1):
		position = get_global_mouse_position()
		velocity = Vector2()


func apply_friction():
	if is_on_floor():
		velocity.x *= 0.9
	if floor_too_long:
		velocity.x = lerp(velocity.x, 0, 0.1)


func apply_gravity():
	velocity.y += 1000


func apply_slope():
	var collider = get_slide_collision(max(0, get_slide_count()-1))
	
	if collider:
		if collider.normal != Vector2(0,-1) and $InputDisableTimer.time_left == 0:
			velocity.y = -(abs(velocity.x)*1.2 + 1000)
			velocity.x = 0
			max_speed_left = -5000
			max_speed_right = 5000
			disable_input = true
			$InputDisableTimer.start()


func propel(body_entered, detecting_area):
	var direction = position - detecting_area.position
	velocity = direction*2000
	if velocity.x < 0:
		max_speed_left = velocity.x
	elif velocity.x > 0:
		max_speed_right = velocity.x
	disable_input = true
	$InputDisableTimer.start()


func is_on_floor_for_too_long():
	if is_on_floor() and $FloorTimer.time_left == 0:
		$FloorTimer.start()
	if !is_on_floor():
		$FloorTimer.stop()
		floor_too_long = false
		

func _on_FloorTimer_timeout():
	max_speed_left = -5000
	max_speed_right = 5000
	velocity.y = 0
	floor_too_long = true


func handle_max_speed_direction():
	if velocity.x < 0:
		max_speed_right = 5000
	elif velocity.x > 0:
		max_speed_left = -5000


func _on_InputDisableTimer_timeout():
	disable_input = false
