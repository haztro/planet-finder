extends HBoxContainer

export(String) var text = ""
export(Color) var colour = Color(1, 1, 1, 1)

var font = preload("res://assets/fonts/font.tres").duplicate()

signal toggled(planet_name, val)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.set("custom_fonts/font", font)
	$Label.get("custom_fonts/font").outline_color = Color(0, 0, 0)
	$Label.set("custom_colors/font_color", colour)
	$Label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameData.planets[$Label.text.to_lower()].selected:
		$Label.get("custom_fonts/font").outline_size = 3
	else:
		$Label.get("custom_fonts/font").outline_size = 0

func _on_CheckBox_toggled(button_pressed):
	emit_signal("toggled", $Label.text.to_lower(), button_pressed)
