extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().connect("size_changed", self, "_on_viewport_size_changed")
	_on_viewport_size_changed()

func _on_viewport_size_changed():
	var window_size = OS.get_window_size()
	rect_size.y = window_size.y
	rect_position = Vector2(0, 0)
	if rect_size.y >= window_size.y:
		rect_scale.y = window_size.y / rect_size.y
		rect_scale.x = rect_scale.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rect = get_global_rect()
	rect.size *= rect_scale
	if rect.has_point(get_global_mouse_position()):
		GameData.mouse_over_gui = 1
	else:
		GameData.mouse_over_gui = 0
	
