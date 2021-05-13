extends Node

var latitude = 0
var longitude = 0

var earth_position = Vector3.ZERO
var target_earth_position = Vector3.ZERO

var date = null
var resolution = Vector2(480, 270)
var rect = null
var mouse_over_gui = 0

var time_passing = 0
var time_speed = 1
var inc = 1
var ticks = 0

var selected_planet = null
var planets = {}

var sun_texture = preload("res://assets/art/sun.jpg")
var mercury_texture = preload("res://assets/art/mercury.jpg")
var venus_texture = preload("res://assets/art/venus.jpg")
var earth_texture = preload("res://assets/art/earth_day.jpg")
var mars_texture = preload("res://assets/art/mars.jpg")
var jupiter_texture = preload("res://assets/art/jupiter.jpg")
var saturn_texture = preload("res://assets/art/saturn.jpg")
var uranus_texture = preload("res://assets/art/uranus.jpg")
var neptune_texture = preload("res://assets/art/neptune.jpg")

var planet_textures = {"sun" : sun_texture, "mercury" : mercury_texture, "venus" : venus_texture, "earth" : earth_texture,
						"mars" : mars_texture, "jupiter" : jupiter_texture, "saturn" : saturn_texture,
						"uranus" : uranus_texture, "neptune" : neptune_texture}

# Called when the node enters the scene tree for the first time.
func _ready():
	date = DateTime.new()
	date.set_datetime(OS.get_datetime())
	rect = Rect2(Vector2.ZERO, resolution)
#	get_tree().connect("screen_resized", self, "_screen_resized")

func _process(delta):
	earth_position += (target_earth_position - earth_position) * 0.3
	earth_position += earth_position.normalized() * (1 - earth_position.length())
	
	if time_passing:
		ticks += delta
		if ticks >= time_speed:
			ticks = ticks - time_speed
			if inc == 0:
				date.add_second(1)
			elif inc == 1:
				date.add_minute(1)
			elif inc == 2:
				date.add_hour(1)
			elif inc == 3:
				date.add_day(1)
			elif inc == 4:
				date.add_month(1)
			elif inc == 5:
				date.add_year(1)

#	compute_latlon_from_rectangular()
#	print(latitude)

func update_selection(planet):
	if selected_planet != null:
		selected_planet.deselect()
	
	planet.select()
	selected_planet = planet
	
func add_planet(planet_name, planet):
	if !planets.has(planet_name):
		planets[planet_name] = planet
	
func set_planet_visibility(planet_name, val):
	planets[planet_name].set_visible(val)
	
func set_earth_position_from_rectangular(pos):
	target_earth_position = pos
	get_latlon_from_rectangular()

func set_latitude(lat):
	latitude = lat
	set_earth_position_from_latlon()
	
func set_longitude(lon):
	longitude = lon
	set_earth_position_from_latlon()
	
func compute_latlon_from_rectangular():
	latitude = rad2deg(asin(earth_position.y))
	longitude = rad2deg(atan2(-earth_position.z, earth_position.x))
	
func get_latlon_from_rectangular():
	latitude = rad2deg(asin(target_earth_position.y))
	longitude = rad2deg(atan2(-target_earth_position.z, target_earth_position.x)) 
	
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
