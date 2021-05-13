extends LineEdit

signal value_changed(dir)

var mouse_over = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	var rect = get_global_rect()
	if rect.has_point(get_global_mouse_position()):
		mouse_over = 1
	else:
		mouse_over = 0
	
func set_value(val):
	text = str(val)

func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_WHEEL_DOWN and mouse_over:
			emit_signal("value_changed", -1)
		elif event.button_index == BUTTON_WHEEL_UP and mouse_over:
			emit_signal("value_changed", 1)


func _on_ScrollBox_focus_exited():
	emit_signal("text_entered", text)
