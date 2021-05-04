extends Spatial


export(Material) var m
export(String) var planet = "sun"
export(float) var distance = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$PlanetMesh.set_surface_material(0, m) 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = GameData.planets[planet].ecliptic.normalized()
	transform.origin = Vector3(pos.x, pos.z, pos.y) * distance
	

