extends Node

signal give_crop_seeds
signal trade_crops
signal player_name_prompt

func action_give_crop_seeds() -> void:
	give_crop_seeds.emit()

func action_trade_crops() -> void:
	trade_crops.emit()

func action_player_name_prompt() -> void:
	player_name_prompt.emit()
