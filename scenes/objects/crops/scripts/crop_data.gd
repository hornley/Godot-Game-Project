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
var growth_speed: float
var fertilizer_power: int

func update() -> void:
	var new_time_until_next_growth_state = time_until_next_growth_state.total_minutes()
	new_time_until_next_growth_state /= (growth_speed + fertilizer_power/100)
	time_until_next_growth_state.update(0, 0, new_time_until_next_growth_state)
