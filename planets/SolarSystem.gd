extends Spatial


var planets = []


# Called when the node enters the scene tree for the first time.
func _ready():
	planets = [$Mercury, $Venus, $Mars, $Jupiter, $Saturn, $Uranus, $Neptune]
	call_deferred("draw_orbit")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func draw_orbit():
	get_node("Draw").clear()
	for c in planets:
		get_node("Draw").begin(Mesh.PRIMITIVE_LINE_LOOP, null) #1 = is an enum for draw line, null is for text
		get_node("Draw").set_color(Color(1, 1, 1, 1))
		
		for i in range(50):
			get_node("Draw").add_vertex(Vector3(cos(i * 2*PI / 50), 0, sin(i * 2*PI / 50)) * c.distance)
		
		get_node("Draw").end()
