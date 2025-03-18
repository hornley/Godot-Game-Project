extends Node

signal give_crop_seeds
signal trade_crops
signal player_name_prompt
signal farmer_shop_gui(option: String)
signal farmer_shop_gui_close

func action_give_crop_seeds() -> void:
	PlayerManager.completed_quests.append(GameDataManager.get_quest("Get Started"))
	give_crop_seeds.emit()

func action_trade_crops() -> void:
	trade_crops.emit()

func action_player_name_prompt() -> void:
	player_name_prompt.emit()

func action_farmer_shop_gui(option: String) -> void:
	farmer_shop_gui.emit(option)
	await farmer_shop_gui_close
