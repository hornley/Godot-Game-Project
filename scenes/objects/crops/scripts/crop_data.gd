class_name CropData
extends Resource

var date_planted: CustomTime #
var time_of_full_growth: CustomTime #
var time_per_growth_state: CustomTime #
var previous_growth_state_time: CustomTime
var time_until_next_growth_state: CustomTime #
var previous_watered_time: CustomTime #
var water_interval: CustomTime #
var time_before_rot: CustomTime #
var growth_speed: float = 1
var growth_speed_multiplier: float = 1.0
var fertilizer_power: int

func update(is_watered: bool) -> void:
	if is_watered:
		growth_speed_multiplier = 1.0
	else:
		growth_speed_multiplier = 0.5
	
	var new_time_until_next_growth_state = time_per_growth_state.total_minutes()
	new_time_until_next_growth_state /= (growth_speed + fertilizer_power/100) * growth_speed_multiplier
	time_until_next_growth_state.update(0, 0, new_time_until_next_growth_state)
