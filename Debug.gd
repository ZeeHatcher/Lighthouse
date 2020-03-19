extends Control

onready var player = get_parent().get_parent()
onready var vbox = get_child(0)

func _ready():
	$VBoxContainer/JumpV.text = str(player.jump_height)
	$VBoxContainer/GravityV.text = str(player.gravity_strength)
	$VBoxContainer/MaxV.text = str(player.max_speed_left) + ", " + str(player.max_speed_right)
	$VBoxContainer/FrictionV.text = str(player.friction_strength)
	$VBoxContainer/ExploV.text = "To be added"
	$VBoxContainer/PositionR.text = str(player.position)

func _process(_delta):
	$VBoxContainer/VelocityV.text = str(player.velocity)
	
	if player.position != null:
		var x = floor(player.position.x)
		var y = floor(player.position.y)
		$VBoxContainer/PositionV.text = str(x) + ", " + str(y)

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		for i in vbox.get_children():
			i.release_focus()
		
		player.jump_height = int($VBoxContainer/JumpV.text)
		player.gravity_strength = int($VBoxContainer/GravityV.text)
		player.friction_strength = float($VBoxContainer/FrictionV.text)
#		player.explosion_strength = int($VBoxContainer/ExploV.text)
		

func _on_Button_pressed():
	var cords = $VBoxContainer/PositionR.text
	cords = str2var("Vector2" + cords) as Vector2
	player.position = cords
