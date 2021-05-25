extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().connect("size_changed", self, "_on_viewport_size_changed")
	_on_viewport_size_changed()
	AudioManager.play("music", -6, 1, 2)
#	var ev = InputEventKey.new()
#	ev.set_scancode(KEY_KP_ENTER)
#	InputMap.action_add_event("ui_accept", ev)

func _on_viewport_size_changed():
	$GUI/MarginContainer.rect_size = OS.get_window_size()
	$ViewportContainer/Viewport.size = OS.get_window_size()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("settings"):
		var button = $GUI/MarginContainer/TextureButton
		if button.disabled:
			AudioManager.play("click", 0, 1.2)
			show_button()
			$GUI/Toolbar.hide_ui()
		else:
			AudioManager.play("click", 0, 1.5)
			hide_button()
			$GUI/Toolbar.show_ui()
	if Input.is_action_just_pressed("mute"):
		AudioManager.toggle_mute()

func hide_button():
	var button = $GUI/MarginContainer/TextureButton
	button.disabled = 1
	$GUI/MarginContainer/Tween.interpolate_property(button, "modulate:a", button.modulate.a, 0, 0.25, 0, 0)
	$GUI/MarginContainer/Tween.start()
	
func show_button():
	var button = $GUI/MarginContainer/TextureButton
	button.disabled = 0
	$GUI/MarginContainer/Tween.interpolate_property(button, "modulate:a", button.modulate.a, 1, 0.25, 0, 0)
	$GUI/MarginContainer/Tween.start()

func _on_TextureButton_pressed():
	AudioManager.play("click", 0, 1.5)
	$GUI/Toolbar.show_ui()
	hide_button()
