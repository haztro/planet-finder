extends "res://planets/Planet3D.gd"

var last_angle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
#	if planet == "earth":
#		rotation.x = deg2rad(23.5)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_position()
	
	
func update_position():
	var vert_swap = Vector3(ecliptic_coords.x, 0, ecliptic_coords.y)
	transform.origin = vert_swap.normalized() * distance
	
	if planet == "earth":
		var date = GameData.date.get_dict()
		var d = PlanetLocator.get_day_number(date)
		var ut: float = date["hour"] + date["minute"] / 60.0 + date["second"] / 3600.0
		var L: float = (356.0470 + 0.9856002585 * d) + (282.9404 + 0.0000470935 * d) # Sun's mean longitude
		var gmst0: float = (L + 180) / 15.0
		var sidetime: float = gmst0 + ut + GameData.longitude / 15
		var hour_angle = PlanetLocator.rev((sidetime*15) - GameData.planets["earth"].RA_decl[0])
		var angle_diff = hour_angle - last_angle
		last_angle = hour_angle
#		print(ecliptic_coords.z)
		var t = Transform()
		t.basis = t.basis.rotated(t.basis.x.normalized(), deg2rad(23.5))
		transform.basis = t.basis.rotated(t.basis.y.normalized(), deg2rad(hour_angle))
#		var pos = GameData.planets["sun"].get_node("PlanetMesh").global_transform.origin
#		var v = pos.normalized()
#		$PlanetMesh.look_at(-pos, Vector3.UP)
#		print(v)
	

