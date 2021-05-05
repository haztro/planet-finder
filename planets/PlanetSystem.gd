extends "res://planets/Planet3D.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_position()
	
	
func update_position():
	var vert_swap = Vector3(ecliptic_coords.x, 0, ecliptic_coords.y)
	transform.origin = vert_swap.normalized() * distance
	

