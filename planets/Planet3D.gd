extends Spatial


export(String) var planet = "moon"
export(float) var radius = 0.5
export(float) var distance = 8

var azimuth = 0
var altitude = 0
var ecliptic_coords = Vector3.ZERO
var RA_decl = [0, 0]
var selected = 0
var draw_lines = 1

var material = preload("res://assets/materials/planet.tres").duplicate()
var arrow_material = preload("res://assets/materials/arrow.tres").duplicate()

# Called when the node enters the scene tree for the first time.
func _ready():
	var mesh = SphereMesh.new()
	mesh.radius = radius
	mesh.height = 1
	$PlanetMesh.mesh = mesh
	material.albedo_texture = GameData.planet_textures[planet]
	$PlanetMesh.set_surface_material(0, material) 
	$Spatial/LinePoint.set_surface_material(0, arrow_material)
	$Spatial/MeshInstance.set_surface_material(0, arrow_material)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_attributes()
	
	$Spatial.transform.origin = $PlanetMesh.transform.origin
	$Spatial.look_at(GameData.earth_position, Vector3.UP)

func update_attributes():
	var date = PlanetLocator.get_utc_date(GameData.date.get_dict(), GameData.longitude)
	var day_number = PlanetLocator.get_day_number(date)
	var orbital_elements = PlanetLocator.get_orbital_elements(planet, day_number)
	ecliptic_coords = PlanetLocator.get_heliocentric_ecliptic_coordinates(orbital_elements)
	RA_decl = PlanetLocator.get_RA_decl(day_number, ecliptic_coords)
	var azi_alt = PlanetLocator.get_azimuth_altitude(orbital_elements, date, day_number, RA_decl[0], RA_decl[1], GameData.latitude, GameData.longitude)
	azimuth = azi_alt[0]
	altitude = azi_alt[1]
	
func select():
	selected = 1
	
func deselect():
	selected = 0
	
func set_visible(val):
	visible = val

func draw_lines(colour):
	get_node("PlanetMesh/Draw").clear()
	get_node("PlanetMesh/Draw").begin(Mesh.PRIMITIVE_LINES, null) #1 = is an enum for draw line, null is for text
	get_node("PlanetMesh/Draw").set_color(colour)

	# get_node("Draw").add_vertex(-transform.origin) + GameData.earth_position)
#	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, 0))
#	get_node("PlanetMesh/Draw").add_vertex(-$PlanetMesh.transform.origin + Vector3(0, 0, 1))
	get_node("PlanetMesh/Draw").add_vertex(-$PlanetMesh.transform.origin + Vector3(0, 0, 1))
	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, -$PlanetMesh.transform.origin.z + 1)) 
	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, -$PlanetMesh.transform.origin.z + 1)) 
	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, -0.5))
	

	
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
				
