extends Node2D


export(String) var planet = "moon"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var a = PlanetLocator.get_planet(planet, GameData.date.get_dict(), GameData.latitude, GameData.longitude)

	if a[1] < 0:
		modulate.a = 0.5
	else:
		modulate.a = 1

#	print(a)

	position = Vector2(cos(deg2rad(a[0])), sin(deg2rad(a[0]))) * cos(deg2rad(a[1])) * 120 + Vector2(240, 130)
