extends Node

const MINUTES_PER_DAY: int = 24 * 60
const MINUTES_PER_HOUR: int = 60
const GAME_MINUTE_DURATION: float = TAU / MINUTES_PER_DAY

var game_speed: float = 3.0

var initial_day: int = 1
var initial_hour: int = 0
var initial_minute: int = 0
var initial_time: CustomTime = CustomTime.new(1, 0, 0)

var time: float = 0.0
var current_day: int = -1
var current_hour: int = -1
var current_minute: int = -1
var current_time: CustomTime = CustomTime.new(-1, -1, -1)

signal game_time(time: float)
signal time_tick(time: CustomTime)
signal time_tick_day(day: int)

func _ready() -> void:
	set_initial_time()

func _process(delta: float) -> void:
	time += delta * game_speed * GAME_MINUTE_DURATION
	game_time.emit(time)
	
	recalculate_time()


func set_initial_time() -> void:
	var initial_total_minutes = initial_time.day * MINUTES_PER_DAY + (initial_time.hour * MINUTES_PER_HOUR) + initial_time.minute
	
	time = initial_total_minutes * GAME_MINUTE_DURATION

func recalculate_time() -> void:
	var total_minutes: int = int(time / GAME_MINUTE_DURATION)
	@warning_ignore("integer_division")
	var day: int = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes: int = total_minutes % MINUTES_PER_DAY
	@warning_ignore("integer_division")
	var hour: int = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute: int = int(current_day_minutes % MINUTES_PER_HOUR)
	
	current_time.day = day
	current_time.hour = hour
	current_time.minute = minute
	
	if current_minute != minute:
		current_minute = minute
		current_hour = hour
		time_tick.emit(current_time)
	
	if current_day != day:
		current_day = day
		time_tick_day.emit(day)
