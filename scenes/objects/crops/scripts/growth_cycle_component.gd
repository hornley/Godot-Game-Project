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

# always starts at 1 until 6
@export var current_growth_state: Util.GrowthStates = Util.GrowthStates.Germination
@export_range(7, 365) var days_until_harvest: int = 7
@export var is_watered: bool
@export var starting_day: int
@export var current_day: int
@export var fertilizer_power: int

var crop_data: CropData

signal crop_maturity
signal crop_harvesting

var num_states = 7 # not including Seed state

func _ready() -> void:
	await get_parent().get_tree().process_frame
	crop_data = get_parent().crop_data
	DayAndNightCycleManager.time_tick.connect(on_time_tick)

func on_time_tick(time: CustomTime) -> void:
	if current_growth_state == Util.GrowthStates.Fruiting:
		return
	
	update(time)

func update(time: CustomTime) -> void:
	if is_watered and time.total_minutes() >= crop_data.previous_watered_time.total_minutes() + crop_data.water_interval.total_minutes():
		is_watered = false
	
	if time.total_minutes() >= crop_data.previous_growth_state_time.total_minutes() + crop_data.time_until_next_growth_state.total_minutes():
		current_growth_state += 1
		crop_data.previous_growth_state_time = time.clone()
		crop_data.time_until_next_growth_state = crop_data.time_per_growth_state

func get_current_growth_state() -> Util.GrowthStates:
	return current_growth_state
