extends KinematicBody2D

# References
onready var cooldown_timer := $AttackCooldownTimer
onready var attack_timer := $AttackTimer
onready var move_timer := $RandomMoveTimer
onready var light := $Light2D
onready var player = ENTITIES.player
onready var fly_projectile = SCENES.projectile_fly

# Initiating values
var velocity := Vector2()
var will_move := true
var can_attack := true

# Entity variables
export var follow_distance := 300          # distance when enemy stops getting closer
export var speed := 100                     # movement speed when approching player
export var attack_charge_time = 1	# attack rate in seconds


func _ready() -> void:
	add_to_group("enemies")
	face_direction()
	attack_timer.wait_time = attack_charge_time

func _physics_process(delta) -> void:
	var distance_to_player = player.global_position.distance_to(global_position)
	if distance_to_player > follow_distance:
		move_towards_player()
	else:
		random_move()
		attack()
		
	move_and_collide(velocity * delta, false)


# face left or right
func face_direction() -> void:
	if player.global_position > global_position:
		$Sprite.flip_h = true
		$Position2D.position.x = 16
		light.position.x = -6
	else:
		$Sprite.flip_h = false
		$Position2D.position.x = -16
		light.position.x = 6

# moves towards the player
func move_towards_player() -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed

# move a little on random
func random_move() -> void:
	if will_move:
		will_move = false                    	# can move again only  #
		move_timer.wait_time = randi() % 2 + 0.1  	# after timer runs out #
		move_timer.start()                   	#  (rand time 0..2 )   #
		
		var rand_x = randi() % 20 - 10       	# generate random int #
		var rand_y = randi() % 20 - 10       	# between -10 and 9   # 
		
		var direction = Vector2(rand_x, rand_y).normalized()   	 # move by 1/10 #
		velocity = direction * speed / 10                      	 # of its speed #

# charges an attack and shoots after the charge
func attack() -> void:
	if can_attack:                	# attacks only if cooldown is over
		can_attack = false        	# no spam attacks until cooldown
		attack_timer.start()      	# resets cooldown timer
		light.visible = true      	# show charging light 

# shoots projectile after charging
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
