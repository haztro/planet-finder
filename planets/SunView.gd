extends "res://planets/PlanetView.gd"




# Called when the node enters the scene tree for the first time.
func _ready():
	material.albedo_color = Color(5, 5, 5, 1)
	print(planet)
	var t = get_node("Sprite3D")
	if t != null:
		remove_child(t)
		$PlanetMesh.add_child(t)
	
				

