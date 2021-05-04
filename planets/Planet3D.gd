extends Spatial


export(String) var planet = "moon"
export(Material) var m
export(float) var radius = 0.5
export(float) var distance = 8

var azimuth = 0
var altitude = 0
var ecliptic = Vector3.ZERO
var selected = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlanetMesh.set_surface_material(0, m) 
	GameData.add_planet(planet, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var a = PlanetLocator.get_planet(planet, GameData.date.get_dict(), GameData.latitude, GameData.longitude)
	azimuth = a[3]
	altitude = a[4]
	ecliptic = Vector3(a[6][0], a[6][1], a[6][2])
	var azi = 90 - a[3]
	var alt = a[4]
	
	var pos = Vector3(cos(deg2rad(azi)) * cos(deg2rad(alt)), sin(deg2rad(azi)) * cos(deg2rad(alt)), sin(deg2rad(alt))) * distance
	$PlanetMesh.transform.origin = pos + Vector3(0, 0, 1)
	
	if transform.origin != -GameData.earth_position.normalized():
		look_at(-GameData.earth_position.normalized(), $PlanetMesh.transform.basis.y)

#	if a[4] > 0:
	draw_lines()
#	else:
#		get_node("PlanetMesh/Draw").clear()

func select():
	selected = 1
	
func deselect():
	selected = 0
	
func set_visible(val):
	visible = val

func draw_lines():
	get_node("PlanetMesh/Draw").clear()
	get_node("PlanetMesh/Draw").begin(Mesh.PRIMITIVE_LINES, null) #1 = is an enum for draw line, null is for text
	get_node("PlanetMesh/Draw").set_color(Color(1, 1, 1, 0.5))
	
	# get_node("Draw").add_vertex(-transform.origin) + GameData.earth_position)
	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, 0))
	get_node("PlanetMesh/Draw").add_vertex(-$PlanetMesh.transform.origin + Vector3(0, 0, 1))
	get_node("PlanetMesh/Draw").add_vertex(-$PlanetMesh.transform.origin + Vector3(0, 0, 1))
	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, -$PlanetMesh.transform.origin.z + 1)) 
	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, -$PlanetMesh.transform.origin.z + 1)) 
	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, 0))
#	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, -$PlanetMesh.transform.origin.z)) 
	
#
#	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, -$PlanetMesh.transform.origin.z - 1))
#	get_node("PlanetMesh/Draw").add_vertex(-$PlanetMesh.transform.origin - Vector3(0, 0, 1))
#	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, 0))
#	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, -$PlanetMesh.transform.origin.z - 1))
	
	get_node("PlanetMesh/Draw").end()


func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				GameData.update_selection(self)
				
