class_name Projectile
extends KinematicBody2D

export (int) var speed = 0
export (String, "projectile_player", "projectile_enemy") var group := "projectile_player"

onready var velocity := Vector2(speed, 0)
onready var hit_box := $CollisionShape2D
onready var sprite := $Sprite
onready var light := $Light2D

func _ready():
	add_to_group(group)

func _physics_process(delta: float) -> void:
	_maneuver(delta)
	
	var collision = move_and_collide(velocity * delta)
	
	if (collision):
		_on_collide(collision.collider)
	
func point_to(target: Vector2) -> void:
	look_at(target)
	velocity = velocity.rotated(rotation)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _maneuver(delta: float) -> void:
	pass

func _on_collide(collider: Object) -> void:
	pass
