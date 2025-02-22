class_name GrowthCycleComponent
extends Node

## Get the current date and time
#var current_time = Time.get_datetime_dict_from_system()
#
## Access specific components
#var year = current_time["year"]
#var month = current_time["month"]
#var day = current_time["day"]
#var hour = current_time["hour"]
#var minute = current_time["minute"]
#var second = current_time["second"]

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var days_until_harvest: int = 7
@export var is_watered: bool
@export var starting_day: int
@export var current_day: int
@export var fertilizer_power: int

signal crop_maturity
signal crop_harvesting


func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	if is_watered:
		if starting_day == 0:
			starting_day = day
			day += fertilizer_power
		
		growth_states(starting_day, day)
		harvest_state(starting_day, day)

func growth_states(starting_day: int, current_day: int):
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
	
	var num_states = 5
	
	var growth_days_passed = (current_day - starting_day) % num_states
	var state_index = growth_days_passed % num_states + 1
	
	current_growth_state = state_index
	
	var name = DataTypes.GrowthStates.keys()[current_growth_state]
	
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()

func harvest_state(starting_day: int, current_day: int):
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
	
	var days_passed = (current_day - starting_day) % days_until_harvest
	
	if days_passed == days_until_harvest - 1 - fertilizer_power:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state
