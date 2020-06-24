extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$vbox/LineEdit.text = "100"
	$vbox/LineEdit2.text = str(get_node("../../Gun").ammo)

func _on_Gun_fired():
	$vbox/LineEdit2.text = str(get_node("../../Gun").ammo)
	
func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		for i in $vbox.get_children():
			i.release_focus()
