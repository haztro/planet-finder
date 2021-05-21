extends Camera

var last_drag_pos = Vector2.ZERO
var is_dragging = 0
var is_panning = 0

var rotate_velocity = Vector2.ZERO
var pan_velocity = Vector2.ZERO
var mouse_motion = Vector2.ZERO

var rotate_friction = 0.3
var rotate_sensitivity = 0.004

var pan_friction = 0.3
var pan_sensitivity = 0.01
var pan_distance = Vector2.ZERO

var zoom_sensitivity = 0.5
var zoom_friction = 0.3
var target_zoom = 35
var current_zoom = 35

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	get_mouse_motion()
	
	if is_dragging and !is_panning:
		update_rotate_velocity()
		
	if is_panning:
		update_pan_velocity()
	
	rotate_velocity -= rotate_velocity * rotate_friction
	pan_velocity -= pan_velocity * pan_friction
	
	var rb = transform.basis.rotated(Vector3.UP, rotate_velocity.x)
	var ro = transform.origin.rotated(Vector3.UP, rotate_velocity.x)
	transform = Transform(rb, ro)
	
	var pitch = transform.basis.get_euler().x + rotate_velocity.y
	if pitch < 1.56 and pitch > -1.56:
		rb = transform.basis.rotated(transform.basis.x.normalized(), rotate_velocity.y)
		ro = transform.origin.rotated(transform.basis.x.normalized(), rotate_velocity.y)
		transform = Transform(rb, ro)

	pan(pan_velocity)
	zoom()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_MIDDLE:
			if !event.is_pressed():
				is_dragging = 0
				is_panning = 0
				
	if get_viewport().get_visible_rect().has_point(get_viewport().get_mouse_position()):
		handle_input(event)

			
func handle_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_MIDDLE:
			last_drag_pos = get_viewport().get_mouse_position()
			if event.is_pressed():
				is_dragging = 1
				if Input.is_key_pressed(KEY_SHIFT):
					is_panning = 1
				else:
					is_panning = 0
			elif !event.is_pressed():
				is_dragging = 0
				is_panning = 0
				
		if event.button_index == BUTTON_WHEEL_DOWN:
			target_zoom = min(target_zoom + zoom_sensitivity, 35)
		elif event.button_index == BUTTON_WHEEL_UP:
			target_zoom = max(target_zoom - zoom_sensitivity, 3)
			
#	get_tree().set_input_as_handled()

func free_rotate(axis, angle):
	var rotated_basis = transform.basis.rotated(axis, angle)
	var rotated_origin = transform.origin.rotated(axis, angle)
	transform = Transform(rotated_basis, rotated_origin)
	
func pan(distance):
	distance *= current_zoom * 0.05
	transform = transform.translated(Vector3(distance.x, -distance.y, 0))
	
func zoom():
	var old_transform = transform.translated(Vector3(0, 0, -current_zoom))
	current_zoom += (target_zoom - current_zoom) * zoom_friction
	transform = old_transform.translated(Vector3(0, 0, current_zoom))
	GameData.update_resolution(current_zoom)
	
func get_mouse_motion():
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_motion = (last_drag_pos - mouse_pos) 
	last_drag_pos = mouse_pos
	
func update_rotate_velocity():
	rotate_velocity += mouse_motion * rotate_sensitivity 
	
func update_pan_velocity():
	pan_velocity += mouse_motion * pan_sensitivity 
	


