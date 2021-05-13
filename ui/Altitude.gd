extends VBoxContainer



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_angle = deg2rad(-GameData.get_selected_altitude())
	var target_pos = Vector2(cos(target_angle), sin(target_angle))
	var current_pos = Vector2(cos($Sprite.rotation), sin($Sprite.rotation))
	
	current_pos += (target_pos - current_pos) * 0.3
	
	$Sprite.rotation = current_pos.angle()
	$HBoxContainer/Label.text = str(int(GameData.get_selected_altitude()))
