extends KinematicBody2D

onready var cooldown_timer = $AttackCooldownTimer
onready var move_timer = $RandomMoveTimer
onready var attack_timer = $AttackTimer
onready var light = $Light2D
onready var player = get_tree().get_root().get_node("TestLab/Player")
onready var fly_projectile = load("res://fly_projectile.tscn")

var follow_distance := 300
var can_attack := true
var velocity := Vector2()
var speed = 100
var will_move = true


func _ready():
	add_to_group("enemies")
	light.visible = false

func _physics_process(delta):
	face_horizontal()        # face left or right
	
	var distance_to_player = player.global_position.distance_to(global_position)
	
	if distance_to_player > follow_distance:
		move_to_player()
	else:
		random_move()
		attack()
	
	move_and_collide(velocity * delta, false)


func face_horizontal():
	if player.global_position > global_position:
		$Sprite.flip_h = true
		$Position2D.position.x = 15
		light.position.x = -6
	else:
		$Sprite.flip_h = false
		$Position2D.position.x = -15
		light.position.x = 6

func move_to_player():
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed

func random_move():
	if will_move:
		will_move = false
		move_timer.wait_time = randi() % 2
		move_timer.start()
		
		# generate random int between 0 and 19
		var rand_x = randi() % 20
		var rand_y = randi() % 20
		
		var direction = Vector2(rand_x-10, rand_y-10).normalized()
		velocity = direction * speed/10

func attack():
	if can_attack:
		can_attack = false
		attack_timer.start()
		light.visible = true

func _on_AttackTimer_timeout():
	cooldown_timer.start()
	var projectile = fly_projectile.instance()
	get_tree().get_root().get_node("TestLab").add_child(projectile)
	projectile.position = $Position2D.global_position
	projectile.point()
	light.visible = false

func _on_RandomMoveTimer_timeout():
	will_move = true

func _on_AttackCooldownTimer_timeout():
	can_attack = true
