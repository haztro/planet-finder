extends VBoxContainer


onready var year_box = get_node("HBoxContainer2/VBoxContainer/YearBox")
onready var month_box = get_node("HBoxContainer2/VBoxContainer2/MonthBox")
onready var day_box = get_node("HBoxContainer2/VBoxContainer3/DayBox")
onready var hour_box = get_node("HBoxContainer2/VBoxContainer4/HourBox")
onready var minute_box = get_node("HBoxContainer2/VBoxContainer5/MinuteBox")
onready var second_box = get_node("HBoxContainer2/VBoxContainer6/SecondBox")

var date = null

# Called when the node enters the scene tree for the first time.
func _ready():
	date = DateTime.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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


func _on_LatBox_value_changed(dir):
	GameData.set_latitude(clamp(GameData.latitude + dir, -90, 90))
	$HBoxContainer/VBoxContainer7/LatBox.set_value(GameData.latitude)

func _on_LonBox_value_changed(dir):
	GameData.set_longitude(clamp(GameData.longitude + dir, -180, 180))
	$HBoxContainer/VBoxContainer8/LonBox.set_value(GameData.longitude)
