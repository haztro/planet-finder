extends VBoxContainer

onready var year_box = get_node("VBoxContainer/PanelContainer4/VBoxContainer/HBoxContainer2/PanelContainer/VBoxContainer/YearBox")
onready var month_box = get_node("VBoxContainer/PanelContainer4/VBoxContainer/HBoxContainer2/PanelContainer2/VBoxContainer2/MonthBox")
onready var day_box = get_node("VBoxContainer/PanelContainer4/VBoxContainer/HBoxContainer2/PanelContainer3/VBoxContainer3/DayBox")
onready var hour_box = get_node("VBoxContainer/PanelContainer4/VBoxContainer/HBoxContainer2/PanelContainer4/VBoxContainer4/HourBox")
onready var minute_box = get_node("VBoxContainer/PanelContainer4/VBoxContainer/HBoxContainer2/PanelContainer5/VBoxContainer5/MinuteBox")
onready var second_box = get_node("VBoxContainer/PanelContainer4/VBoxContainer/HBoxContainer2/PanelContainer6/VBoxContainer6/SecondBox")

onready var lat_box = get_node("VBoxContainer2/PanelContainer2/HBoxContainer/PanelContainer/VBoxContainer7/LatBox")
onready var lon_box = get_node("VBoxContainer2/PanelContainer2/HBoxContainer/PanelContainer2/VBoxContainer8/LonBox")

var date = null

# Called when the node enters the scene tree for the first time.
func _ready():
	date = DateTime.new()
	date = GameData.date
	update_all_boxes()
	
	lat_box.set_value(GameData.latitude)
	lon_box.set_value(GameData.longitude)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	lat_box.set_value(GameData.latitude)
#	lon_box.set_value(GameData.longitude)
#	update_all_boxes()
	pass

func update_all_boxes():
	year_box.set_value(date.year)
	month_box.set_value(date.month)
	day_box.set_value(date.day)
	hour_box.set_value(date.hour)
	minute_box.set_value(date.minute)
	second_box.set_value(date.second)
	GameData.date = date

func _on_YearBox_value_changed(dir):
	date.add_year(dir)
	update_all_boxes()
	
func _on_MonthBox_value_changed(dir):
	date.add_month(dir)
	update_all_boxes()
		
func _on_DayBox_value_changed(dir):
	date.add_day(dir)
	update_all_boxes()

func _on_HourBox_value_changed(dir):
	date.add_hour(dir)
	update_all_boxes()

func _on_MinuteBox_value_changed(dir):
	date.add_minute(dir)
	update_all_boxes()

func _on_SecondBox_value_changed(dir):
	date.add_second(dir)
	update_all_boxes()


func _on_YearBox_text_entered(new_text):
	if new_text.is_valid_integer():
		date.set_year(int(new_text))
	update_all_boxes()

func _on_MonthBox_text_entered(new_text):
	if new_text.is_valid_integer():
		date.set_month(int(new_text))
	update_all_boxes()

func _on_DayBox_text_entered(new_text):
	if new_text.is_valid_integer():
		date.set_day(int(new_text))
	update_all_boxes()

func _on_HourBox_text_entered(new_text):
	if new_text.is_valid_integer():
		date.set_hour(int(new_text))
	update_all_boxes()

func _on_MinuteBox_text_entered(new_text):
	if new_text.is_valid_integer():
		date.set_minute(int(new_text))
	update_all_boxes()

func _on_SecondBox_text_entered(new_text):
	if new_text.is_valid_integer():
		date.set_second(int(new_text))
	update_all_boxes()


func _on_LatBox_value_changed(dir):
	GameData.set_latitude(clamp(GameData.latitude + dir, -90, 90))
	lat_box.set_value(GameData.latitude)

func _on_LonBox_value_changed(dir):
	GameData.set_longitude(clamp(GameData.longitude + dir, -180, 180))
	lon_box.set_value(GameData.longitude)


func _on_LatBox_text_entered(new_text):
	if new_text.is_valid_float():
		GameData.set_latitude(clamp(float(new_text), -90, 90))
	lat_box.set_value(GameData.latitude)

func _on_LonBox_text_entered(new_text):
	if new_text.is_valid_float():
		GameData.set_longitude(clamp(float(new_text), -180, 180))
	lon_box.set_value(GameData.longitude)


func _on_TextureButton_pressed():
	date.set_datetime(OS.get_datetime())
	GameData.date = date
	update_all_boxes()
	

func _on_TextureButton2_toggled(button_pressed):
	GameData.time_passing = button_pressed

func _on_HSlider_value_changed(value):
#	if value < 1.667:
#		GameData.time_speed = 1 - (value / 1.667)
#		GameData.inc = 0
#	elif value < 3.33:
#		GameData.time_speed = (1 - (value - 1.667) / 1.667)
#		GameData.inc = 1
#	elif value < 5:
#		GameData.time_speed = (1 - (value - 3.33) / 1.667) * 0.5
#		GameData.inc = 2
#	elif value < 6.67:
#		GameData.time_speed = (1 - (value - 5) / 1.667) * 0.5
#		GameData.inc = 3
#	elif value < 8.33:
#		GameData.time_speed = (1 - (value - 6.67) / 1.667) * 0.5
#		GameData.inc = 4
#	elif value < 10:
#		GameData.time_speed = (1 - (value - 8.33) / 1.667) * 0.5
#		GameData.inc = 5
	GameData.time_speed = 1 - sqrt(value)
			

