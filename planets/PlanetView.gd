extends "res://planets/Planet3D.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	material.flags_unshaded = 1
	GameData.add_planet(planet, self)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_position()


func update_position():
	var azi = 90 - azimuth
	var alt = altitude
	var pos = Vector3(cos(deg2rad(azi)) * cos(deg2rad(alt)), sin(deg2rad(azi)) * cos(deg2rad(alt)), sin(deg2rad(alt))) * distance
	$PlanetMesh.transform.origin = pos + Vector3(0, 0, 1)
	
	if transform.origin != -GameData.earth_position.normalized():
		look_at(-GameData.earth_position.normalized(), $PlanetMesh.transform.basis.y)

	draw_lines()
	
				

