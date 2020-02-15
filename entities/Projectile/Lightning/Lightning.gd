extends Line2D

# References
onready var level := get_tree().get_root().get_node("TestLab")
onready var area : Area2D = $Area2D
onready var shock_timer = $ShockTimer
var scene_lightning = load("res://entities/Projectile/Lightning/Lightning.tscn")

# Max number of enemies targeted = max_chain_targets ^ max_chain_length + all the previously hit enemies

export (int) var max_chain_targets := 2     	# Max number of branch offs in each iteration
export (int) var max_chain_length := 3      	# Max distance a lightning can travel per branch
export (int) var min_chain_radius := 100    	# Radius of lightning branch

var chained_length = 0
var enemies_hit = []
var lines = []

func _ready():
	area.get_node("CollisionShape2D").get_shape().radius = min_chain_radius

func shock():
	shock_timer.start()
	animate_lightning()

func animate_lightning():
	visible = false
	
	var next_point := Vector2()
	var previous_point := points[0]
	var percentage_passed := 0.0
	var length = points[0].distance_to(points[1])
	var iterations = int(length / 20) + 1.0
	var percentage_increase = 1.0/iterations
	
	for i in range(iterations):
		# create line
		lines.append(Line2D.new())
		level.add_child(lines[i])
		lines[i].width = 1
		
		# calculate line position
		percentage_passed += percentage_increase
		next_point = points[0].linear_interpolate(points[1], percentage_passed)
		if i != iterations-1:
			next_point.x += rand_range(-10, 10) 
			next_point.y += rand_range(-10, 10)
		var new_vectors = PoolVector2Array([previous_point, next_point])
		
		# set line position
		lines[i].position = position
		lines[i].points = new_vectors
		
		previous_point = next_point

func _on_ShockTimer_timeout():
	# get near enemies
	var overlap_objects = area.get_overlapping_bodies()
	var overlap_enemies = []
	for i in range(overlap_objects.size()):
		if overlap_objects[i].is_in_group("enemies") && !enemies_hit.has(overlap_objects[i]):
			overlap_enemies.append(overlap_objects[i])
	
	# get the closest enemies
	var target_enemies = []
	var min_distance = 10000
	var closest_enemy_index = -1
	for x in range(max_chain_targets):
		min_distance = 10000
		closest_enemy_index = -1
		for i in range(overlap_enemies.size()):
			if overlap_enemies[i].position.distance_to(position + points[1]) < min_distance:
				min_distance = overlap_enemies[i].position.distance_to(position + points[1])
				closest_enemy_index = i
		if closest_enemy_index != -1:
			target_enemies.append(overlap_enemies[closest_enemy_index])
			overlap_enemies.remove(closest_enemy_index)
			if overlap_enemies.size() == 0:
				break
	
	# hit those enemies, kill the enemies, make more lightning
	for i in range(target_enemies.size()):
			if chained_length >= max_chain_length:
				break
			else:
				var lightning : Line2D = scene_lightning.instance()
				level.add_child(lightning)
				
				lightning.global_position = area.global_position
				lightning.set_point_position(1, target_enemies[i].global_position - area.global_position)
				lightning.area.position = target_enemies[i].global_position - area.global_position
				lightning.chained_length = chained_length + 1
				lightning.enemies_hit = enemies_hit
				
				lightning.shock()
				
				enemies_hit.append(target_enemies[i])
				target_enemies[i].queue_free()
	
	# kill itself
	for line in lines:
		line.queue_free()
	queue_free()
