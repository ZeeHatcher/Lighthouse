extends Line2D

# References
onready var level := get_tree().get_root().get_node("TestLab")
onready var area : Area2D = $Area2D
onready var scene_lightning = load("res://assets/Lightning.tscn")

export (int) var max_chain_targets := 2
export (int) var max_chain_length := 3
export (int) var min_chain_radius := 100

var chained_length = 0

func _ready():
	area.get_node("CollisionShape2D").get_shape().radius = min_chain_radius


func _physics_process(delta):
	var chained = 0
	var overlap_objects = area.get_overlapping_bodies()
	var overlap_enemies = []
	for i in range(overlap_objects.size()):
		if overlap_objects[i].is_in_group("enemies"):
			overlap_enemies.append(overlap_objects[i])
	
	var target_enemies = []
	var min_distance = 10000
	var closest_enemy_index = null
	for x in range(max_chain_targets):
		min_distance = 10000
		closest_enemy_index = -1
		for i in range(overlap_enemies.size()):
			if overlap_enemies[i].position.distance_to(points[1]) < min_distance:
				min_distance = overlap_enemies[i].position.distance_to(position)
				closest_enemy_index = i
		if closest_enemy_index != -1:
			target_enemies.append(overlap_enemies[closest_enemy_index])
			overlap_enemies.remove(closest_enemy_index)
	
	
	for i in range(target_enemies.size()):
			if chained_length < max_chain_length:
				
				var lightning : Line2D = scene_lightning.instance()
				level.add_child(lightning)
				lightning.global_position = area.global_position
				#lightning.look_at(overlap_objects[i].global_position)   for rotating light only
				lightning.set_point_position(1, target_enemies[i].global_position - area.global_position)
				lightning.area.position = target_enemies[i].global_position - area.global_position
				lightning.chained_length = chained_length + 1
				
				target_enemies[i].queue_free()
				
	queue_free()
