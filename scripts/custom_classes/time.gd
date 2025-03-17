extends Resource

class_name CustomTime

@export var day: int
@export var hour: int
@export var minute: int

# Constructor
func _init(d: int = 0, h: int = 0, m: int = 0):
	day = d
	hour = h
	minute = m
	_normalize_time()

func clone() -> CustomTime:
	return CustomTime.new(day, hour, minute)

func update(d: int = 0, h: int = 0, m: int = 0):
	day = d
	hour = h
	minute = m
	_normalize_time()

func update_day(d: int = day):
	day = d
	_normalize_time()

func update_hour(h: int = hour):
	hour = h
	_normalize_time()

func update_minute(m: int = minute):
	minute = m
	_normalize_time()

# Convert time to total minutes for easy math
func total_minutes() -> int:
	return (day * 24 * 60) + (hour * 60) + minute

# Operator Overloading: Allows subtraction using -
func diff(other: CustomTime) -> CustomTime:
	var res = total_minutes() - other.total_minutes()
	return CustomTime.new(res / (24 * 60), (res / 60) % 24, res % 60)

# Normalize time (prevents negative hours/minutes from breaking)
func _normalize_time():
	while minute >= 60:
		minute -= 60
		hour += 1
	while hour >= 24:
		hour -= 24
		day += 1
	while minute < 0:
		minute += 60
		hour -= 1
	while hour < 0:
		hour += 24
		day -= 1
