extends Camera

var last_drag_pos = Vector2.ZERO
var is_dragging = 0

var rotate_velocity = Vector2.ZERO
var pan_velocity = Vector2.ZERO
var mouse_motion = Vector2.ZERO

var rotate_friction = 0.3
var rotate_sensitivity = 0.004

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	get_mouse_motion()
	
	if is_dragging:
		update_rotate_velocity()
	
	rotate_velocity -= rotate_velocity * rotate_friction
	
	var rb = transform.basis.rotated(Vector3.UP, rotate_velocity.x)
	var ro = transform.origin.rotated(Vector3.UP, rotate_velocity.x)
	transform = Transform(rb, ro)
	
	var pitch = transform.basis.get_euler().x + rotate_velocity.y
	if pitch < 1.56 and pitch > -1.56:
		transform.basis = transform.basis.rotated(transform.basis.x.normalized(), rotate_velocity.y)
#		ro = transform.origin.rotated(transform.basis.x.normalized(), rotate_velocity.y)
#		transform = Transform(rb, ro)
	
func _unhandled_input(event):
	handle_input(event)
			
func handle_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_MIDDLE:
			last_drag_pos = get_viewport().get_mouse_position()
			if event.is_pressed():
				is_dragging = 1
			elif !event.is_pressed():
				is_dragging = 0
			
#	get_tree().set_input_as_handled()

func free_rotate(axis, angle):
	var rotated_basis = transform.basis.rotated(axis, angle)
	var rotated_origin = transform.origin.rotated(axis, angle)
	transform = Transform(rotated_basis, rotated_origin)
	
func get_mouse_motion():
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_motion = (last_drag_pos - mouse_pos) 
	last_drag_pos = mouse_pos
	
func update_rotate_velocity():
	rotate_velocity += mouse_motion * rotate_sensitivity 

	

