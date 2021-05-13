extends HBoxContainer

export(String) var text = ""
export(Color) var colour = Color(1, 1, 1, 1)


signal toggled(planet_name, val)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.modulate = colour
	$Label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CheckBox_toggled(button_pressed):
	emit_signal("toggled", $Label.text.to_lower(), button_pressed)
