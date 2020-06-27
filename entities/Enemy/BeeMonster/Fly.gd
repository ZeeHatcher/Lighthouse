extends Enemy
export var attack_range := 0		# distance when enemy stops getting closer
#export var attack_charge_time = 1		# attack rate in seconds

var can_attack := true
onready var bulb := $Light2D
onready var tail := $Tail
onready var timer_attack_cooldown := $AttackCooldownTimer
onready var timer_attack_charge := $AttackChargeTimer
#onready var timer_move := $RandomMoveTimer
onready var projectile_insect := preload("res://entities/Projectile/InsectShot/InsectShot.tscn")

var box := Rect2(Vector2(0,0), Vector2(0,0))

func _attack(_delta: float) -> void:
	if (can_attack && global_position.distance_to(level.lighthouse.global_position) < attack_range):
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
	box.position = tail.position
	box.size = Vector2(10,10)
	pass

# warning-ignore:unused_argument
func _move(delta: float) -> void:
	match side:
		Side.LEFT:
			velocity = Vector2(speed, 0)
			
		Side.RIGHT:
			velocity = Vector2(-speed, 0)

func move_towards_player() -> void:
	var direction = (level.lighthouse.global_position - global_position).normalized()
	velocity = direction * speed

func _on_AttackCooldownTimer_timeout():
	can_attack = true

func _on_AttackChargeTimer_timeout():
	#Instance from singleton
	var projectile = projectile_insect.instance()
	level.add_child(projectile)
	projectile.position = tail.global_position
	projectile.point_to(level.lighthouse.global_position)
	bulb.visible = false

	timer_attack_cooldown.start()

func _on_RandomMoveTimer_timeout():
	pass
