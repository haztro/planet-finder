extends VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_MercuryCheckbox_toggled(planet_name, val):
	AudioManager.play("click", 0, 1.5)
	GameData.set_planet_visibility(planet_name, val)


func _on_VenusCheckbox_toggled(planet_name, val):
	AudioManager.play("click", 0, 1.5)
	GameData.set_planet_visibility(planet_name, val)


func _on_MarsCheckbox_toggled(planet_name, val):
	AudioManager.play("click", 0, 1.5)
	GameData.set_planet_visibility(planet_name, val)


func _on_JupiterCheckbox_toggled(planet_name, val):
	AudioManager.play("click", 0, 1.5)
	GameData.set_planet_visibility(planet_name, val)


func _on_SaturnCheckbox_toggled(planet_name, val):
	AudioManager.play("click", 0, 1.5)
	GameData.set_planet_visibility(planet_name, val)


func _on_UranusCheckbox_toggled(planet_name, val):
	AudioManager.play("click", 0, 1.5)
	GameData.set_planet_visibility(planet_name, val)


func _on_NeptuneCheckbox_toggled(planet_name, val):
	AudioManager.play("click", 0, 1.5)
	GameData.set_planet_visibility(planet_name, val)


func _on_SunCheckbox_toggled(planet_name, val):
	AudioManager.play("click", 0, 1.5)
	GameData.set_planet_visibility(planet_name, val)
