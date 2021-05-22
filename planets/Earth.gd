extends Spatial


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $MarkerMesh.transform.origin != GameData.earth_position:
		$MarkerMesh.look_at(GameData.earth_position, Vector3.UP)



func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				GameData.set_earth_position_from_rectangular(click_position)
