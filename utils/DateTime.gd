class_name DateTime

enum Month { JAN = 1, FEB = 2, MAR = 3, APR = 4, MAY = 5, JUN = 6, JUL = 7,
		AUG = 8, SEP = 9, OCT = 10, NOV = 11, DEC = 12 }

var year: int = 1970
var month: int = 1
var day: int = 1
var hour: int = 0
var minute: int = 0
var second: int = 0

func get_dict() -> Dictionary:
	var d = {"year":year, "month":month, "day":day, "hour":hour, "minute":minute, "second":second}
	return d

func set_datetime(y, mon, d, h, m, s) -> void:
	set_year(y)
	set_month(mon)
	set_day(d)
	set_hour(h)
	set_minute(m)
	set_second(s)
	
func add_datetime(y, mon, d, h, m, s) -> void:
	add_second(s)
	add_minute(m)
	add_hour(h)
	add_day(d)
	add_month(mon)
	add_year(y)
	
# Setters
func set_year(y) -> void:
	year = int(clamp(y, 1970, 2100))
	
func set_month(m) -> void:
	month = int(clamp(m, 1, 12))
	set_day(day)
	
func set_day(d) -> void:
	day = int(clamp(d, 1, get_days_in_month(month, year)))
	
func set_hour(h) -> void:
	hour = int(clamp(h, 0, 23))
	
func set_minute(m) -> void:
	minute = int(clamp(m, 0, 59))
	
func set_second(s) -> void:
	second = int(clamp(s, 0, 59))
	
# Adders
func add_year(y):
	year = clamp(year + y, 1970, 2100)
	return year
	
func add_month(m):
	if month + m > 12:
		add_year(1)
		set_month(1)
	elif month + m < 1:
		add_year(-1)
		set_month(12)
	else:
		set_month(month + m)
	return month
		
func add_day(d):
	if day + d > get_days_in_month(month, year):
		add_month(1)
		set_day(1)
	elif day + d < 1:
		add_month(-1)
		set_day(get_days_in_month(month, year))
	else:
		set_day(day + d)
	return day
	
func add_hour(h):
	if hour + h > 23:
		add_day(1)
		set_hour(0)
	elif hour + h < 0:
		add_day(-1)
		set_hour(23)
	else:
		set_hour(hour + h)
	return hour
	
func add_minute(m):
	if minute + m > 59:
		add_hour(1)
		set_minute(0)
	elif minute + m < 0:
		add_hour(-1)
		set_minute(59)
	else:
		set_minute(minute + m)
	return minute
	
func add_second(s):
	if second + s > 59:
		add_minute(1)
		set_second(0)
	elif second + s < 0:
		add_minute(-1)
		set_second(59)
	else:
		set_second(second + s)
	return second
	
func get_days_in_month(month : int, year : int) -> int:
	var number_of_days : int
	if (month == Month.APR or month == Month.JUN or month == Month.SEP or month == Month.NOV):
		number_of_days = 30
	elif (month == Month.FEB):
		var is_leap_year = (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)
		if is_leap_year:
			number_of_days = 29
		else:
			number_of_days = 28
	else:
		number_of_days = 31
	
	return number_of_days

