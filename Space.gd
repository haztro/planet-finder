extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $DirectionalLight.transform.origin != -$Sun.get_node("PlanetMesh").global_transform.origin:
		$DirectionalLight.look_at(-$Sun.get_node("PlanetMesh").global_transform.origin, Vector3.UP)
	
	

	

