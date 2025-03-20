extends Node

signal talk_to_guide
signal trade_crops
signal player_name_prompt
signal farmer_shop_gui(option: String)
signal farmer_shop_gui_close

func action_talk_to_guide() -> void:
	PlayerManager.complete_quest("Talk to Guide")
	PlayerManager.add_quest(GameDataManager.get_quest("Get Started"))

func action_get_started() -> void:
	PlayerManager.complete_quest("Get Started")

func action_trade_crops() -> void:
	trade_crops.emit()

func action_player_name_prompt() -> void:
	player_name_prompt.emit()

func action_farmer_shop_gui(option: String) -> void:
	farmer_shop_gui.emit(option)
	await farmer_shop_gui_close
