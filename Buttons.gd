extends Button

onready var res = preload("res://SpeedMan.png")
onready var vbox = get_node("..")

func _ready():
	# signals for menu selection
	connect('focus_entered', self, '_on_focus_change')
	connect('focus_exited', self, '_on_focus_leave')
	# selected the first option by default
	get_parent().get_child(0).grab_focus()
	# signals for the functionality of buttons
	connect('pressed', self, '_on_button_pressed')

func _is_first():
	return get_index() == 0

func _is_last():
	return get_index() == get_parent().get_children().size() - 1

func _gui_input(event):
	# Assuming the buttons are in a container and no other controls exist as siblings
	# except for other buttons in the list...
	if event.is_action("ui_down") and _is_last() and not event.is_echo() and event.pressed:
		call_deferred("focus_top")
	if event.is_action("ui_up") and _is_first() and not event.is_echo() and event.pressed:
		call_deferred("focus_bottom")

func focus_top():
	if _is_last():
		get_parent().get_child(0).grab_focus()

func focus_bottom():
	if _is_first():
		get_parent().get_child(get_parent().get_children().size()-1).grab_focus()

func _on_focus_change():
	get_node(".").icon = res

func _on_focus_leave():
	get_node(".").icon = null
	
func _on_button_pressed():
	match get_index():
		0:
			get_tree().change_scene("res://Game.tscn")
		1:
			print("test2")
		2:
			get_tree().quit()
