extends Node2D

onready var scene_tree := get_tree()
onready var root := scene_tree.get_root()
onready var level := root.get_node("TestLab")

onready var sprite := $Sprite
onready var muzzle := $Muzzle
var ammo := 10
var ammo_toggle = false
signal fired
signal outofammo

#func fire() -> void:
#	var bullet := SCENES.projectile_bullet.instance()
#	level.add_child(bullet)
#
#	bullet.global_position = muzzle.global_position
#	bullet.point_to(get_global_mouse_position())


onready var scene_lightning = preload("res://entities/Projectile/Lightning/Lightning.tscn")
func fire():
	emit_signal("fired")
	if ammo != 0:
		ammo -= 1
		var lightning : Line2D = scene_lightning.instance()
		level.add_child(lightning)
	
		lightning.global_position = muzzle.global_position
		lightning.set_point_position(1, get_global_mouse_position() - muzzle.global_position)
		lightning.area.position = get_global_mouse_position() - muzzle.global_position
		lightning.shock()
	else:
		emit_signal("outofammo")
		
		if ammo_toggle == false: 
			$Eject.play()
			ammo_toggle = true

func reload():
	ammo_toggle = false
	ammo = 10
	$Reload.play()


func _on_Reload_finished():
	emit_signal("fired")
