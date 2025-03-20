extends PanelContainer

@onready var silver_coin_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/SilverCoinLabel
@onready var gold_coin_label: Label = $MarginContainer/HBoxContainer/VBoxContainer2/GoldCoinLabel

func _ready() -> void:
	PlayerManager.player_coin_updated.connect(on_player_coin_updated)

func on_player_coin_updated(coins: int) -> void:
	gold_coin_label.text = str(coins / 10)
	silver_coin_label.text = str(coins % 10)
