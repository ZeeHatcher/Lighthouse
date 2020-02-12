extends Enemy

export var attack_range := 0		# distance when enemy stops getting closer
export var attack_charge_time = 1		# attack rate in seconds

var can_attack := true

onready var bulb := $Light2D
onready var tail := $Tail
onready var timer_attack_cooldown := $AttackCooldownTimer
onready var timer_attack_charge := $AttackChargeTimer
onready var timer_move := $RandomMoveTimer

func _attack(delta: float) -> void:
	if (can_attack && global_position.distance_to(ENTITIES.lighthouse.global_position) < attack_range):
		bulb.visible = true
		timer_attack_charge.start()
		can_attack = false

func _flip() -> void:
	match side:
		Side.LEFT:
			sprite.flip_h = false
			
		Side.RIGHT:
			sprite.flip_h = true

func _on_spawn() -> void:
	pass

func _move(delta: float) -> void:
	match side:
		Side.LEFT:
			velocity = Vector2(speed, 0)
			
		Side.RIGHT:
			velocity = Vector2(-speed, 0)

func move_towards_player() -> void:
	var direction = (ENTITIES.lighthouse.global_position - global_position).normalized()
	velocity = direction * speed

func _on_AttackCooldownTimer_timeout():
	can_attack = true

func _on_AttackChargeTimer_timeout():
	var projectile = SCENES.projectile_fly.instance()
	ENTITIES.level.add_child(projectile)
	projectile.position = tail.global_position
	projectile.point()
	bulb.visible = false

	timer_attack_cooldown.start()

func _on_RandomMoveTimer_timeout():
	pass
