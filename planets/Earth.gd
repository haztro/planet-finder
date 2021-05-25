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
				AudioManager.play("click", 0, rand_range(0.55, 0.75))
				click_position.x = clamp(click_position.x, -1, 1)
				click_position.y = clamp(click_position.y, -1, 1)
				click_position.z = clamp(click_position.z, -1, 1)
				GameData.set_earth_position_from_rectangular(click_position)
