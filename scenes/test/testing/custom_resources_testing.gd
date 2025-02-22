extends Node2D

var game_data_path: String = "user://game_data"

func _ready() -> void:
	GameDataManager.create_new_item("Sword", "omsim", 1)
	GameDataManager.save_game_data(game_data_path)
