extends Control

func _ready():
	$vbox/HPV.text = "100"
	$vbox/AmmoV.text = str(get_node("../../Gun").ammo)

func _on_Gun_fired():
	$vbox/AmmoV.text = str(get_node("../../Gun").ammo)
	
func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		for i in $vbox.get_children():
			i.release_focus()
