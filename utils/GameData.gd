extends Node

var latitude = 0
var longitude = 0

var earth_position = Vector3.ZERO
var target_earth_position = Vector3.ZERO

var date = null
var resolution = Vector2(480, 270)
var rect = null
var mouse_over_gui = 0

var selected_planet = null
var planets = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	date = DateTime.new()
	rect = Rect2(Vector2.ZERO, resolution)
#	get_tree().connect("screen_resized", self, "_screen_resized")

func _process(delta):
	earth_position += (target_earth_position - earth_position) * 0.3
	earth_position += earth_position.normalized() * (1 - earth_position.length())
	compute_latlon_from_rectangular()

func update_selection(planet):
	if selected_planet != null:
		selected_planet.deselect()
	
	planet.select()
	selected_planet = planet
	
func add_planet(planet_name, planet):
	planets[planet_name] = planet
	
func set_planet_visibility(planet_name, val):
	planets[planet_name].set_visible(val)
	
func set_earth_position_from_rectangular(pos):
	target_earth_position = pos

func set_latitude(lat):
	latitude = lat
	set_earth_position_from_latlon()
	
func set_longitude(lon):
	longitude = lon
	set_earth_position_from_latlon()
	
func compute_latlon_from_rectangular():
	latitude = rad2deg(asin(earth_position.y))
	longitude = rad2deg(atan2(-earth_position.z, earth_position.x))
	
func set_earth_position_from_latlon():
	target_earth_position.x = cos(deg2rad(latitude)) * cos(deg2rad(-longitude))
	target_earth_position.z = cos(deg2rad(latitude)) * sin(deg2rad(-longitude))
	target_earth_position.y = sin(deg2rad(latitude))
	
func get_selected_azimuth():
	if selected_planet != null:
		return selected_planet.azimuth
	return 0
	
func get_selected_altitude():
	if selected_planet != null:
		return selected_planet.altitude
	return 0

func update_resolution(new_distance):
	var ratio = int(pow(new_distance / 35.0, 0.4) * 40)
	resolution.x = ratio * 16
	resolution.y = ratio * 9