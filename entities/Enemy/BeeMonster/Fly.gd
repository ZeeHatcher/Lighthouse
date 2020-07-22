extends Enemy
export var attack_range := 0		# distance when enemy stops getting closer
#export var attack_charge_time = 1		# attack rate in seconds

var can_attack := true
onready var bulb := $Light2D
onready var tail := $Tail
#onready var timer_move := $RandomMoveTimer
onready var projectile_insect := preload("res://entities/Projectile/InsectShot/InsectShot.tscn")

#var box := Rect2(Vector2(0,0), Vector2(0,0))

onready var AttackChargeTimer = get_tree().create_timer(0.0) # 1s
#export var charge_timer = 1.0 # only works for seconds because of process i think
onready var AttackCooldownTimer = get_tree().create_timer(0.0) # 1s
#export var cooldown_timer = 1.0
onready var RandomMoveTimer = get_tree().create_timer(0.0) # 1s
	
func _process(delta):
	if AttackChargeTimer.time_left <= 0.0:
		yield(AttackChargeTimer, "timeout")
		AttackCharge()
	if AttackCooldownTimer.time_left <= 0.0:
		yield(AttackCooldownTimer, "timeout")
		AttackCooldown()
		

func _attack(_delta: float) -> void:
	if (can_attack && global_position.distance_to(level.lighthouse.global_position) < attack_range):
		bulb.visible = true
		AttackChargeTimer = get_tree().create_timer(1.0)
		can_attack = false

func _flip() -> void:
	match side:
		Side.LEFT:
			sprite.flip_h = false
			
		Side.RIGHT:
			sprite.flip_h = true
#
#func _on_spawn() -> void:
#	box.position = tail.position
#	box.size = Vector2(10,10)
#	pass

func _move(delta: float) -> void:
	match side:
		Side.LEFT:
			velocity = Vector2(speed, 0)
			
		Side.RIGHT:
			velocity = Vector2(-speed, 0)

func move_towards_player() -> void:
	var direction = (level.lighthouse.global_position - global_position).normalized()
	velocity = direction * speed

func AttackCooldown():
	can_attack = true

func AttackCharge():
	#Instance from singleton
	var projectile = projectile_insect.instance()
	level.add_child(projectile)
	projectile.position = tail.global_position
	projectile.point_to(level.lighthouse.global_position)
	bulb.visible = false

	AttackCooldownTimer = get_tree().create_timer(1.0)

func _on_RandomMoveTimer_timeout():
	pass
