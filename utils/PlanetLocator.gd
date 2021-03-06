extends Node

const ECLIPTIC_INCLINE = 23.4406

var body = {"N":0, "i":0, "w":0, "a":0, "e":0, "M":0, "L":0}

var orbital_elements= {
	"mercury":[48.3313, 0.0000324587, 7.0047, 0.00000005, 29.1241, 0.0000101444, 
		0.387098, 0, 0.205635, 0.000000000559, 168.6562, 4.0923344368, 0],
	"venus":[76.6799, 0.000246590, 3.3946, 0.0000000275, 54.8910, 0.0000138374,	
		0.723330, 0, 0.006773, -0.000000001302, 48.0052, 1.6021302244, 0],
	"mars":[49.5574, 0.0000211081,	1.8497, -0.0000000178, 286.5016, 0.0000292961, 
		1.523688, 0, 0.093405, 0.000000002516, 18.6021, 0.5240207766, 0],
	"jupiter":[100.4542, 0.0000276854, 1.3030, -0.0000001557, 273.8777, 0.0000164505, 
		5.2056, 0, 0.048498, 0.000000004469, 19.8950, 0.0830853001, 0],
	"saturn":[113.6634, 0.0000238980, 2.4886, -0.0000001081, 339.3939, 0.0000297661,
		9.66576, 0, 0.055546, -0.000000009499, 316.967, 0.0334442282, 0],
	"uranus":[74.0005, 0.000013978, 0.7733, 0.000000019, 96.6612, 0.000030565,
		19.18171, -0.0000000155, 0.047318, 0.00000000745, 152.5905, 0.011725806, 0],
	"neptune":[131.7806, 0.000030173, 1.77, -0.000000255, 272.8461, -0.000006027,
			30.05826, 0.00000003313, 0.008606, 0.00000000215, 260.2471, 0.005995147, 0],
	"sun":[0, 0, 0, 0, 282.9404, 0.0000470935, 1.0, 0, 0.016709, 0.000000001151, 
		356.047, 0.9856002585, 0],
	"moon":[125.1228, -0.0529538083, 5.1454, 0, 318.0634, 0.1643573223, 60.2666, 
		0, 0.0549, 0, 115.3654, 13.0649929509, 0],
	"earth":[-11.26, 0, 0, 0, 282.9404, 0.0000470935, -1.0, 0, 0.016709, 0.000000001151, 
		356.047, 0.9856002585, 0]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Trig functions that take degrees instead of radians
func sind(x: float) -> float:
	return sin(deg2rad(x))
	
func cosd(x: float) -> float:
	return cos(deg2rad(x))
	
func tand(x: float) -> float:
	return tan(deg2rad(x))
	
func asind(x: float) -> float:
	return rad2deg(asin(x))
	
func acosd(x: float) -> float:
	return rad2deg(acos(x))
	
func atand(x: float) -> float:
	return rad2deg(atan(x))
	
func atan2d(y: float, x: float) -> float:
	return rad2deg(atan2(y, x))

func myatan2(y: float, x: float) -> float:
	if x > 0:
		return atan2d(y, x);
	if x < 0:
		return atan2d(y, x) + 180.0;
	if y < 0:
		return -90.0;
	return 90.0;


func rev(x: float) -> float:
	var new_x = x - floor(x / 360.0) * 360.0
	if x < 0:
		new_x += 360
	return new_x
	
func get_utc_date(date, longitude: float):
	# Convert time to UTC time based on longitude
	var time_difference: float = longitude / 15.0
	date["hour"] = fmod((date["hour"] - time_difference), 24.0)
	return date
	
func get_day_number(date) -> float:
	var Y: int = date["year"]
	var M: int = date["month"]
	var D: int = date["day"]
	# UT is in hours + decimals 
	var UT: float = date["hour"] + date["minute"] / 60.0 + date["second"] / 3600.0

#	var dn: int = 367*Y - (7*(Y + ((M+9)/12)))/4 + (275*M)/9 + D - 730530
	var dn: int = 367*Y - 7 * (Y + (M+9)/12) / 4 - 3 * ((Y + (M-9)/7) / 100 + 1) / 4 + 275 * M / 9 + D - 730515;

	return dn + UT / 24.0


func get_heliocentric_ecliptic_coordinates(body) -> Vector3:
	body["M"] = rev(body["M"])
	
	# Compute eccentric anomaly E from mean anomaly M (do two interations for higher accuracy)
	var E0: float = body["M"] + (180.0 / PI) * body["e"] * sind(body["M"]) * (1 + body["e"] * cosd(body["M"]))
	var E1: float = E0 - (E0 - (180.0 / PI) * body["e"] * sind(E0) - body["M"]) / (1 - body["e"] * cosd(E0))

	# Compute distance and true anomaly
	var x: float = body["a"] * (cosd(E1) - body["e"])
	var y: float = body["a"] * sqrt(1 - body["e"] * body["e"]) * sind(E1)

	var r: float = sqrt(x * x + y * y) 	# Distance
	var v: float = atan2d(y, x)			# True anomaly
	
	# Body position in heliocentric ecliptic coordinates (rectangular coords)
	var x_e: float = r * (cosd(body["N"]) * cosd(v + body["w"]) - sind(body["N"]) * sind(v + body["w"]) * cosd(body["i"]))
	var y_e: float = r * (sind(body["N"]) * cosd(v + body["w"]) + cosd(body["N"]) * sind(v + body["w"]) * cosd(body["i"]))
	var z_e: float = r * sind(v + body["w"]) * sind(body["i"])
	
#	# Polar coordinates (ecliptic) - NOT USED IN CALC
#	var lon: float = atan2d(y_e, x_e)
#	var lat: float = atan2d(z_e, sqrt(x_e * x_e + y_e * y_e))
#	r = sqrt(x_e * x_e + y_e * y_e + z_e * z_e)
	
	return Vector3(x_e, y_e, z_e)

func get_RA_decl(day_number: float, ecliptic_coords: Vector3) -> Array:
	var x_e: float = ecliptic_coords.x
	var y_e: float = ecliptic_coords.y
	var z_e: float = ecliptic_coords.z

	# COMPUTE SUN POSITION
	var sun = get_orbital_elements("sun", day_number)

	sun["M"] = rev(sun["M"])
	
	# Compute eccentric anomaly (one iteration is enough here)
	var E = sun["M"] + (180.0 / PI) * sun["e"] * sind(sun["M"]) * (1 + sun["e"] * cosd(sun["M"]))

	# Compute sun's rectangular coords in plane of the ecliptic (x-axis points toward perihelion)
	var xv: float = cosd(E) - sun["e"]
	var yv: float = sqrt(1.0 - sun["e"] * sun["e"]) * sind(E)

	# Compute distance and true anomaly
	var rs: float = sqrt(xv * xv + yv * yv)
	var vs: float = atan2d(yv, xv)
	
	# Compute longitude of the sun
	var lonsun: float = vs + sun["w"]

	# Compute sun's ecliptic rectangular coordinates
	var xs: float = rs * cosd(lonsun)
	var ys: float = rs * sind(lonsun)
	var zs: float = 0.0

	# Add planet position to sun position
	var new_x: float = xs + x_e
	var new_y: float = ys + y_e
	var new_z: float = zs + z_e

	# ROTATE by 23.4 to get equatorial coords
	var x_eq: float = new_x
	var y_eq: float = new_y * cosd(ECLIPTIC_INCLINE) - new_z * sind(ECLIPTIC_INCLINE)
	var z_eq: float = new_y * sind(ECLIPTIC_INCLINE) + new_z * cosd(ECLIPTIC_INCLINE)

	# Right ascension and declination
	var RA: float = atan2d(y_eq, x_eq)
	var rg: float = sqrt(x_eq * x_eq + y_eq * y_eq + z_eq * z_eq)
	var decl: float = atan2d(z_eq, sqrt(x_eq * x_eq + y_eq * y_eq))

	return [RA, decl]
	
	
func get_azimuth_altitude(body, date, d: float, RA: float, decl: float, latitude: float, longitude: float) -> Array:
	# Determine sidereal time,azimuth,altitude. 
	var ut: float = date["hour"] + date["minute"] / 60.0 + date["second"] / 3600.0
	var L: float = (356.0470 + 0.9856002585 * d) + (282.9404 + 0.0000470935 * d) # Sun's mean longitude
	var gmst0: float = (L + 180) / 15.0
	var sidetime: float = gmst0 + ut + longitude / 15.0

	var hour_angle: float = rev((sidetime*15) - RA)
	
	# Convert to rectangular coords. x-axis points to celestial equator in the south, y-axis points
	# to the horizon in the west, z-axis points to north celestial pole. 
	var x: float = cosd(hour_angle) * cosd(decl)
	var y: float = sind(hour_angle) * cosd(decl)
	var z: float = sind(decl)

	# Rotate about y-axis so that z-axis points to zenith 
	var xhor: float = x * sind(latitude) - z * cosd(latitude)
	var yhor: float = y
	var zhor: float = x * cosd(latitude) + z * sind(latitude)

	var azimuth: float = atan2d(yhor, xhor) + 180
	var altitude: float = atan2d(zhor, sqrt(xhor*xhor + yhor*yhor))
	
	return [azimuth, altitude] 

func get_orbital_elements(planet: String, day_number):
	var body = {}
	body["N"] = orbital_elements[planet][0] + orbital_elements[planet][1] * day_number
	body["i"] = orbital_elements[planet][2] + orbital_elements[planet][3] * day_number
	body["w"] = orbital_elements[planet][4] + orbital_elements[planet][5] * day_number
	body["a"] = orbital_elements[planet][6] + orbital_elements[planet][7] * day_number
	body["e"] = orbital_elements[planet][8] + orbital_elements[planet][9] * day_number
	body["M"] = orbital_elements[planet][10] + orbital_elements[planet][11] * day_number
	body["L"] = orbital_elements[planet][12]
	return body
	
	

