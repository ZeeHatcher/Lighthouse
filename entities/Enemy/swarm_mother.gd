extends Enemy

onready var spawn_timer = $SpawnTimer

var swarmfly = preload("res://entities/Enemy/swarmfly.tscn")

var swarm_size = 20
var swarm_list = []

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
	var direction = (level.lighthouse.global_position - global_position).normalized()
	velocity = direction * speed
	
func _on_SpawnTimer_timeout():
	for i in range(swarm_size):
		var fly = swarmfly.instance()
		level.add_child(fly)
		swarm_list.append(fly)
		fly.position = position
		fly.position.x += rand_range(-100, 100)
		fly.position.y += rand_range(-100, 100)
