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
var is_visible = 1
var target_value = 1

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
	if $Spatial.transform.origin != GameData.earth_position:
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
	if !is_visible:
		$Tween.interpolate_property(arrow_material, "albedo_color", arrow_material.albedo_color, Color(1, 1, 1, 0), 0.2, 0, 1)
	else:
		$Tween.interpolate_property(arrow_material, "albedo_color", arrow_material.albedo_color, Color(1, 1, 1, target_value), 0.2, 0, 1)
	$Tween.start()
		
func deselect():
	selected = 0
	if !is_visible:
		$Tween.interpolate_property(arrow_material, "albedo_color", arrow_material.albedo_color, Color(0.48, 0.81, 0.44, 0), 0.2, 0, 1)
	else:
		$Tween.interpolate_property(arrow_material, "albedo_color", arrow_material.albedo_color, Color(0.48, 0.81, 0.44, target_value), 0.2, 0, 1)
	$Tween.start()
	
func set_visible(val):
#	visible = val
#	is_visible = val
	if val:
		$Tween.interpolate_property(arrow_material, "albedo_color:a", arrow_material.albedo_color.a, target_value, 0.1, 0, 0)
		$Tween.interpolate_property(material, "albedo_color:a", material.albedo_color.a, target_value, 0.1, 0, 0)
		if planet == "saturn":
			var m = get_node("PlanetMesh/MeshInstance").get_surface_material(0)
			$Tween.interpolate_property(m, "albedo_color:a", m.albedo_color.a, target_value, 0.1, 0, 0)
	else:
		is_visible = val
		$Tween.interpolate_property(arrow_material, "albedo_color:a", arrow_material.albedo_color.a, 0, 0.1, 0, 0)
		$Tween.interpolate_property(material, "albedo_color:a", material.albedo_color.a, 0, 0.1, 0, 0)
		if planet == "saturn":
			var m = get_node("PlanetMesh/MeshInstance").get_surface_material(0)
			$Tween.interpolate_property(m, "albedo_color:a", m.albedo_color.a, 0, 0.1, 0, 0)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	is_visible = val

func draw_lines(colour):
#	get_node("PlanetMesh/Draw").clear()
#	get_node("PlanetMesh/Draw").begin(Mesh.PRIMITIVE_LINES, null) #1 = is an enum for draw line, null is for text
#	get_node("PlanetMesh/Draw").set_color(colour)
#
#	get_node("PlanetMesh/Draw").add_vertex(-$PlanetMesh.transform.origin + Vector3(0, 0, 1))
#	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, -$PlanetMesh.transform.origin.z + 1)) 
#	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, -$PlanetMesh.transform.origin.z + 1)) 
#	get_node("PlanetMesh/Draw").add_vertex(Vector3(0, 0, 0))
#
#	get_node("PlanetMesh/Draw").end()
	
	pass


func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed() and is_visible:
				AudioManager.play("click", 0, 0.4)
				GameData.update_selection(self)
				
