extends Control

signal value_changed(dir)

var direction = 0
var mouse_over = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	if $VBoxContainer2.get_global_rect().has_point(get_global_mouse_position()):
		mouse_over = 1
	else:
		mouse_over = 0
	
func set_value(val):
	$VBoxContainer2/Label.text = str(val)
	
func _on_TextureButton_button_down():
	direction = 1
	$DelayTimer.start()
	emit_signal("value_changed", direction)

func _on_TextureButton_button_up():
	$Timer.stop()
	$DelayTimer.stop()

func _on_TextureButton2_button_down():
	direction = -1
	$DelayTimer.start()
	emit_signal("value_changed", direction)

func _on_TextureButton2_button_up():
	$Timer.stop()
	$DelayTimer.stop()

func _on_Timer_timeout():
	emit_signal("value_changed", direction)
	
func _on_DelayTimer_timeout():
	$Timer.start()


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN and mouse_over:
			emit_signal("value_changed", -1)
		elif event.button_index == BUTTON_WHEEL_UP and mouse_over:
			emit_signal("value_changed", 1)

