extends Enemy
export var attack_range := 0		# distance when enemy stops getting closer
#export var attack_charge_time = 1		# attack rate in seconds

var can_attack := true
onready var bulb := $Light2D
onready var tail := $Tail
onready var timer_attack_cooldown := $AttackCooldownTimer
onready var timer_attack_charge := $AttackChargeTimer

onready var projectile_insect := preload("res://entities/Projectile/InsectShot/InsectShot.tscn")

func _ready() -> void:
	add_to_group("Bee")

func _attack(_delta: float) -> void:
	if (can_attack and global_position.distance_to(level.lighthouse.global_position) < attack_range):
		bulb.visible = true
		timer_attack_charge.start()
		can_attack = false

func _flip() -> void:
	match side:
		Side.LEFT:
			sprite.flip_h = false
			
		Side.RIGHT:
			sprite.flip_h = true
			
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
	if (level.get_node("Player") != null):
		projectile.point_to(level.get_node("Player").global_position)
	bulb.visible = false

	timer_attack_cooldown.start()
