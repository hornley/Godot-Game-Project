extends Control

@onready var day_label: Label = $DayPanel/MarginContainer/DayLabel
@onready var time_label: Label = $TimePanel/MarginContainer/TimeLabel

@export var normal_speed: int = 3
@export var fast_speed: int = 100
@export var cheater_speed: int = 200


func _ready() -> void:
	DayAndNightCycleManager.time_tick.connect(on_time_tick)


func on_time_tick(time: CustomTime) -> void:
	day_label.text = "Day " + str(time.day)
	time_label.text = "%02d:%02d" % [time.hour, time.minute]


func _on_normal_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = normal_speed


func _on_fast_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = fast_speed


func _on_cheater_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = cheater_speed
